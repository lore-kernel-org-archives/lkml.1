Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYH0M4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYH0M4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYH0M4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:56:22 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:2799 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbYH0M4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:56:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PTB8VV/Mdg2dmgLfrUaOcoGDxZJyPg+8u35ztJwc+taFKHpmgPYp+ElakjkPIHZc1X
         NC9hXZCeaXpjlBD7jzoUcyHvH3HQ+GUUhD7a6xAGcU+d3LEF1LQMT6tu2ljfvrsnJEBA
         xOZFUkf9SXfyW1Uyz9SuxATuVXnclegn64nX8=
Message-ID: <f7848160808270556q54c36270ye6a465d2ca123cc@mail.gmail.com>
Date: Wed, 27 Aug 2008 08:56:19 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Bernd Petrovitsch" <bernd@firmix.at>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Ingo Molnar" <mingo@elte.hu>, linux-embedded@vger.kernel.org
In-Reply-To: <1219827609.30209.29.camel@spike.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
	 <alpine.LFD.1.10.0808261019450.3363@nehalem.linux-foundation.org>
	 <20080826183051.GB10925@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261144510.3363@nehalem.linux-foundation.org>
	 <20080826205916.GB11734@cs181140183.pp.htv.fi>
	 <alpine.LFD.1.10.0808261403360.3363@nehalem.linux-foundation.org>
	 <f7848160808261554j2f4eaaa6i1ee8801ae75ca7bf@mail.gmail.com>
	 <alpine.LFD.1.10.0808261644260.3363@nehalem.linux-foundation.org>
	 <f7848160808261758q7b84aab1m188c1ebb59304818@mail.gmail.com>
	 <1219827609.30209.29.camel@spike.firmix.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 5:00 AM, Bernd Petrovitsch <bernd@firmix.at> wrote:

>
> They probably gave the idea pretty soon because you need to
> rework/improve large parts of the kernel + drivers (and that has two
> major problems - it consumes a lot of man power for "no new features and
> everything must be completely tested again"[0] and it adds new risks).
> And that is practically impossible if one sells "stable driver APIs" for
> 3rd party (commercial) drivers because these must be changed too.
>

But not many embedded Linux arches support 4K stacks like Adrian
pointed out earlier.
So the same (lot of man power requirement) would apply to Linux.

Sure it will be good - but how reasonable it is to attempt it and how
reliably it will work under all conceived loads - those are the
questions.

Thanks

Parag
