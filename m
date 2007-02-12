Return-Path: <linux-kernel-owner+w=401wt.eu-S965291AbXBLScZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965291AbXBLScZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965289AbXBLScY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:32:24 -0500
Received: from smtp-out.google.com ([216.239.33.17]:16823 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965288AbXBLScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:32:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VgCK055wEAtkuLs1MaTlAvsH5hTxP6u1yOz+BZC55MG+lSx/PjmvdccFBhcNne0WI
	9qE5vBclt0NH/KuXgb5mA==
Message-ID: <6599ad830702121031p16b88cd0vc81f400d213a812f@mail.gmail.com>
Date: Mon, 12 Feb 2007 10:31:48 -0800
From: "Paul Menage" <menage@google.com>
To: "Cedric Le Goater" <clg@fr.ibm.com>
Subject: Re: [PATCH 3/7] containers (V7): Add generic multi-subsystem API to containers
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, vatsa@in.ibm.com,
       sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org, pj@sgi.com,
       ebiederm@xmission.com, winget@google.com, rohitseth@google.com
In-Reply-To: <45D08E2B.4010400@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.485337000@menage.corp.google.com>
	 <20070212153949.GA16014@sergelap.austin.ibm.com>
	 <45D08E2B.4010400@fr.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Cedric Le Goater <clg@fr.ibm.com> wrote:
> >> +#include <asm/proto.h>
> >
> > I did have a problem with this include.  On s390 it didn't exist so I've
> > just been running without it (with no problems).  A quick 'find'
> > suggests it only exists on x86_64, so I'd expect failures on all other
> > arches.
>
> confirmed on x86 also.
>

Sorry, this turned out to be left over from when I was debugging an
initialization problem that required early_printk(). I should have
removed it.

You can safely remove it from the patch.

Paul
