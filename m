Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbZKHOz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbZKHOz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 09:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZKHOz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 09:55:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51875 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbZKHOz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 09:55:56 -0500
Date: Sun, 8 Nov 2009 15:55:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <petkovbb@googlemail.com>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] x86, amd-ucode: Check UCODE_MAGIC before loading the
 container file
Message-ID: <20091108145550.GA12290@elte.hu>
References: <20091029134552.GC30802@alberich.amd.com>
 <20091108120418.GV11372@elte.hu>
 <20091108141017.GA9595@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108141017.GA9595@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> Hi Ingo,
> 
> On Sun, Nov 08, 2009 at 01:04:18PM +0100, Ingo Molnar wrote:
> > hm, there's no changelog. How was it found,
> 
> code staring :)
> 
> > what's the significance,
> 
> required by design.
> 
> > do we want it for .32 - i suspect we want - but we need a better
> > changelog for that.
> 
> Yes. How's that?
> 
> --
> >From f41bced57e05c8adc0d2c13864b6323c191d45d2 Mon Sep 17 00:00:00 2001
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Thu, 29 Oct 2009 14:00:54 +0100
> Subject: [PATCH] x86, amd-ucode: Check UCODE_MAGIC before loading the container file
> 
> When loading a microcode binary, we should check the microcode magic
> value embedded in the image before continuing loading. The original
> check got lost somehow so re-add it to the firmware requesting path.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/kernel/microcode_amd.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)

Looks good - thanks!

	Ingo
