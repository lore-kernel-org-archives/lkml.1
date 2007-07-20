Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbXGTV0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbXGTV0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbXGTV0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:26:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:53088 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbXGTV0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:26:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=P302TzlLdLBAMCe2lkenjT4LhiMpWMdq9blbU47H6RKPl+ifjix9zn59meaJW16v0
	ZOIj0+b3HvHFoTl0pRIfA==
Message-ID: <6599ad830707201425u4c91965bq14e9dce10a1fb4a4@mail.gmail.com>
Date: Fri, 20 Jul 2007 14:25:41 -0700
From: "Paul Menage" <menage@google.com>
To: "James Morris" <jmorris@namei.org>
Subject: Re: [PATCH 02/10] Task Containers(V11): Add tasks file interface
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
       devel@openvz.org
In-Reply-To: <Line.LNX.4.64.0707201616240.9702@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070720183152.637820000@menage.corp.google.com>
	 <20070720191247.556709000@menage.corp.google.com>
	 <Line.LNX.4.64.0707201616240.9702@d.namei>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, James Morris <jmorris@namei.org> wrote:
> > +             if ((current->euid) && (current->euid != tsk->uid)
> > +                 && (current->euid != tsk->suid)) {
> > +                     put_task_struct(tsk);
> > +                     return -EACCES;
>
> I wonder if we should allow CAP_SYS_ADMIN to do this, too.
>

Yes, I ought to replace "current->euid" with "capable(CAP_SYS_ADMIN)".

Thanks,

Paul
