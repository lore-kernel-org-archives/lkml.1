Return-Path: <linux-kernel-owner+w=401wt.eu-S1161219AbXBOUtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161219AbXBOUtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161220AbXBOUtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:49:20 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14803 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161219AbXBOUtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:49:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ePrqjxeRaRHxFH7TIqOqYyIXAjCs/1gBHNXUDVV+MKZQDab0S2v6toIW/P5gHcjq6
	Ekb0RpzffLfTd8bfU03Nw==
Message-ID: <6599ad830702151249i1a8537ebnea7fe5b3cc1ddfe0@mail.gmail.com>
Date: Thu, 15 Feb 2007 12:49:04 -0800
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 2/7] containers (V7): Cpusets hooked into containers
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       vatsa@in.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <20070215203517.GA30344@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.290909000@menage.corp.google.com>
	 <20070215203517.GA30344@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >
> >  config CONTAINERS
> > -     bool "Container support"
> > -     help
> > -       This option will let you create and manage process containers,
> > -       which can be used to aggregate multiple processes, e.g. for
> > -       the purposes of resource tracking.
> > -
> > -       Say N if unsure
> > +     bool
>
> Hi,
>
> why did you do this?
>

Containers on their own aren't all that useful, other than for process
tracking, so it seemed reasonable to only build containers if there
was some subsystem using them. If people wanted to use them for
process tracking alone, it could certainly be made an
individually-selectable option.

Paul
