Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZFGSqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZFGSqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 14:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZFGSq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 14:46:29 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:60736 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbZFGSq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 14:46:28 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Grozdan <neutrino8@gmail.com>
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
Date: Sun, 7 Jun 2009 13:46:19 -0500
User-Agent: KMail/1.9.9
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, tj@kernel.org, alan@lxorguk.ukuu.org.uk
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com> <4A2BF785.3020402@gmail.com> <c5bd819b0906071124j21270574h44db963bdc0b552d@mail.gmail.com>
In-Reply-To: <c5bd819b0906071124j21270574h44db963bdc0b552d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906071346.28021.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun June 7 2009, Grozdan wrote:
> 2009/6/7 Robert Hancock <hancockrwd@gmail.com>:
> > Grozdan wrote:
> >>
> >> 2009/6/6 Robert Hancock <hancockrwd@gmail.com>:
> >>>
> >>> Thing is somehow the GTM detection isn't working now and it apparently
> >>> was
> >>> in 2.6.27.1. I'm not seeing any patches to pata_via or libata-acpi that
> >>> seem
> >>> like they would affect this offhand. Grozdan, would you be able to try
> >>> git
> >>> bisect to try to figure out what changed the behavior?
> >>>
> >>> CCing Tejun in case he has any ideas..
> >>>
> >>
> >> I've no idea how and where to do a git bisect so if someone is willing
> >> to explain in simple steps, I can try...
> >
> > Linus's post on here is a pretty simple explanation:
> >
> > http://kerneltrap.org/node/11753
> >
> 
> Yes, it's clear to someone who's familiar with git but not to a noob
> like me. Where do I run this git? After it's finished what to do next?
> How many times do I have to compile kernels? Which kernels exactly?
> After booting a "bad" kernel, what then? etc... From reading the
> article, the guy has to compile 14!! times just to catch a problem
> between kernel 2.6.21 and 2.6.22. 
>

The article presumes the simple case of a single commit being the
problem.  If the problem involves more than one. . .

Think of doing a binary search in a list of values with duplicate
entries.  ;)

> I guess in my case I'll have to 
> compile a lot more than 14 times to catch something between kernel
> 2.6.27 and 2.6.30 and honestly I don't have time for this right now.
>

Yes, it can get to be time-consuming unless your lucky.

> However, I did a diff between the pata_via driver of kernel 2.6.27 and
> 2.6.30 and there have been changes to it but I'm not sure if they
> affect the cable detection...
>

That's a start.  Now if you knew what you where looking for...
(No offense intended - "diff" doesn't place "here I am" markers.)

The machine I am doing my own tests on uses the pata_via driver and
it detects the udma66 disk drive as a udma33 - - -

But finding this is way down on my list of things to look for -
Someone else is welcome to beat me to it.

Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


