Return-Path: <linux-kernel-owner+w=401wt.eu-S966257AbYD1TIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966257AbYD1TIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934379AbYD1TIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:08:13 -0400
Received: from qb-out-0506.google.com ([72.14.204.230]:22478 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933938AbYD1TIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:08:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PYfLlMRueo5kwF4USIzV127uflgr8GsC1vW1FNTbiwIDyAuKFjuibqtgj4vXEM0Fq/JwscxaqDV4g0Uwrwsdd/D0psC4nnstpwrEo+FEtS4N4uRngKcZUtuQkS5n1+fGUwTzdasfqrio0VWnFukmIGP3bbp6KrmLKLqIlmD4lYU=
Message-ID: <86802c440804281208n7cb7a03cj1a06b49ea15afb7b@mail.gmail.com>
Date: Mon, 28 Apr 2008 12:08:09 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Cc: "Mika Fischer" <mika.fischer@zoopnet.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, balajirrao@gmail.com,
       "Andi Kleen" <andi@firstfloor.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <4815DE0C.6000802@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801192045.17291.yinghai.lu@sun.com>
	 <20080426035614.a30afb17.akpm@linux-foundation.org>
	 <48132665.8050202@googlemail.com>
	 <86802c440804272344yac6a9f0n40809169424247e6@mail.gmail.com>
	 <48159668.5010808@googlemail.com>
	 <86802c440804280234y5b38b4bds330fc1a6987202c5@mail.gmail.com>
	 <48159ECF.9020004@googlemail.com> <20080428135351.GF3973@elte.hu>
	 <4815DB15.4070908@zoopnet.de> <4815DE0C.6000802@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 7:24 AM, Gabriel C <nix.or.die@googlemail.com> wrote:
> Mika Fischer wrote:
>  > Hi Ingo,
>  >
>  > I'm having the same problem.
>  >
>  > Ingo Molnar schrieb:
>  >> excellent. So just to make sure: this box never had proper graphics
>  >> under Linux (under no previous kernel), due to the way the BIOS has set
>  >> up the MTRR's, right?
>  >
>  > Well, not quite. X still works fine, but since the video memory is
>  > overlapped by two of the existing MTRRs, X cannot add a write-combining
>  > range for the video memory. That makes X rather slow especially if you
>  > use DRI for Compiz etc.
>
>  Well you are lucky then :)
>
>  Yeah X 'worked' but it worked as slow as with vesa video driver here.
>
>  Also starting something like supertuxkart made it crash or I got a black screen :(
>
>  The only game I managed to start ( without X to crash ) without that patch was supertux but is was slow as hell.
>  However I'm not a gamer but I need X to work right.
>
or can you change graphics card memory in BIOS to some big like 256M
instead of 64M?

YH
