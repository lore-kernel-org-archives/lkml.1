Return-Path: <linux-kernel-owner+w=401wt.eu-S1751667AbXCHEWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbXCHEWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 23:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbXCHEWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 23:22:11 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:12773 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbXCHEWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 23:22:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qN/2PVTN9pgaLfVp1NCTcXXrZ66lYGMICh2ha4kwO0Jwn6jWCnReVCr3pzK/UQyoUk0xLQZkbOJQ8BCFawVdqvQpVgiAFXh4OtsVtgEnOGxGeR7+RY8c6kpygrFH8BB6z5y7Nsa+gnASwataEN+BNYKRFugXzBfwtL8/mMnD67Q=
Message-ID: <8cd998d50703072022v2bbf1fd9y41b5496f90062e6@mail.gmail.com>
Date: Thu, 8 Mar 2007 15:22:08 +1100
From: "Con Kolivas" <kernel@kolivas.org>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] [RSDL-mm 0/6] RSDL cpu scheduler for -mm
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
In-Reply-To: <20070307185430.31fb48b8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703071226.43238.kernel@kolivas.org>
	 <20070307174345.4c398171.akpm@linux-foundation.org>
	 <20070307185430.31fb48b8.akpm@linux-foundation.org>
X-Google-Sender-Auth: 3533f25650179311
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 7 Mar 2007 17:43:45 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > On Wed, 7 Mar 2007 12:26:42 +1100
> > Con Kolivas <kernel@kolivas.org> wrote:
> >
> > > What follows is the same patch series that constitutes the RDSL "Rotating
> > > Staircase DeadLine" cpu scheduler resynced for 2.6.21-rc2-mm2.
> >
> > Big oops early in boot on x86_64 SMP, in rq_bitmap_error+0x97/0x9f.
> >
> > I stubbed it out with a `return MAX_RT_PRIO;' (I think) but it then oopsed
> > differently.  Before netconsole had come up, no serial console, no digital
> > camera.
> >
> > There's stuff in http://userweb.kernel.org/~akpm/ck/ - you can probably
> > boot that kernel on your own machine.
> >
> > I need to do rc3-mm1 now.  I might find some time to poke at this
> > further after that, but I have to leave for a week in .jp and it'll be
> > squeezy, sorry.
>
> well it boots os dual pIII and quad powerpc.
>
> The powerpc says
>
> Scheduler bitmap error - bitmap being reconstructed..
>
> during bootup.  But it didn't crash like the Nocona machine.

Ah thanks. Sorry I have a very busy day at work and am unable to do
anything about it till tonight. I could imagine on nocona this would
be due to the idle task being scheduled on init - which it is not
supposed to do but if you read the comment in sched_init it says it
*might. I have no way of handling that at the moment because I wasn't
sure it ever happened any more.  As for the powerpc.. I have no idea
(from where I am at the moment which it would be totally inappopriate
for me to try to debug :P), sorry.

--
-ck
