Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbZJSFWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbZJSFWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 01:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZJSFWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 01:22:39 -0400
Received: from mail-vw0-f184.google.com ([209.85.212.184]:32863 "EHLO
	mail-vw0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZJSFWj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 01:22:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=kz3RTy6tkqsIY4ez27HfG7yR5UsKsmnwSIR2hnj1kuhhDlrzIuRe6wTB4PkShg3LfB
         e+2GyVsZ5r/I0YAThLDINYc29cysqtAMG51YApfyvMoFngFFr/P7j3SCFxso8HWdy7pC
         m3MyjVBhxlIakxa6lh1Pf3w1ITcxFDC9dbR1A=
MIME-Version: 1.0
In-Reply-To: <b2b2f2320910182217m31ce0a96g4912eeb9bea5f817@mail.gmail.com>
References: <1255819715-19763-1-git-send-email-linus.walleij@stericsson.com>
	 <b2b2f2320910182217m31ce0a96g4912eeb9bea5f817@mail.gmail.com>
Date: Sun, 18 Oct 2009 23:22:43 -0600
Message-ID: <b2b2f2320910182222y2e3eb5f3qa5010ee60a413141@mail.gmail.com>
Subject: Re: [PATCH] Make MIPS dynamic clocksource/clockevent clock code 
	generic
From: Shane McDonald <mcdonald.shane@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello:

On Sat, Oct 17, 2009 at 4:48 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
>
> This moves the clocksource_set_clock() and clockevent_set_clock()
> from the MIPS timer code into clockchips and clocksource where
> it belongs. The patch was triggered by code posted by Mikael
> Pettersson duplicating this code for the IOP ARM system. The
> function signatures where altered slightly to fit into their
> destination header files, unsigned int changed to u32 and inlined.
>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mikael Pettersson <mikpe@it.uu.se>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> ---
> Ralf has stated in earlier conversation that this should be moved,
> now we risk duplicating code so let's move it.
>
> I don't have access to a MIPS cross-compiler so please can the
> MIPS people test this?

I have tested this patch on an RM7000-based MIPS system.  The patch
compiles fine, and the kernel successfully runs.  You can add my:

Tested-by: Shane McDonald <mcdonald.shane@gmail.com>

Shane
