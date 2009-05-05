Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZEEHg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZEEHg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 03:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbZEEHgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 03:36:48 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:61453 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZEEHgr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 03:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=OAfP1anfXRV3rosa5zGopBpD9bzeP1Ze5tWIDZ1lVzOqbaOGmx2K+jFXNYaoB3xeOg
         H9HQhkTCzgauGrVnUgF5PzPIZv4zqMdKKKD/e/tt2CTK2pNc9h+oT1s1vCbgYLEzgb9b
         tGDRliinWve2dqGf0MgXMKitP6YvqSYwqrQBM=
MIME-Version: 1.0
In-Reply-To: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
References: <1240080744-14995-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 5 May 2009 09:36:45 +0200
X-Google-Sender-Auth: 5a5b3cd15f6e6973
Message-ID: <10f740e80905050036o49b536betc40125c2944eb7ec@mail.gmail.com>
Subject: Re: [PATCH/RFC 0/16] m68k: Device model patches
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 20:52, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> This set of patches brings Amiga hardware support better in line with to the
> Linux device model:
>  - Add module alias support for Zorro drivers (not all drivers can
>    benefit from this yet though, as some still use zorro_find_device()
>    instead of struct zorro_driver),
>  - Convert the various builtin Amiga hardware to the platform driver
>    framework.
>
> [01] platform: Make platform resources input parameters const
> [02] m68k: amiga - Zorro bus modalias support
> [03] m68k: amiga - Zorro host bridge platform device conversion
> [04] m68k: amiga - Frame buffer platform device conversion
> [05] m68k: amiga - Sound platform device conversion
> [06] m68k: amiga - Floppy platform device conversion
> [07] m68k: amiga - A3000 SCSI platform device conversion
> [08] m68k: amiga - A4000T SCSI platform device conversion
> [09] m68k: amiga - Amiga Gayle IDE platform device conversion
> [10] m68k: amiga - Keyboard platform device conversion
> [11] m68k: amiga - Mouse platform device conversion
> [12] m68k: amiga - Serial port platform device conversion
> [13] m68k: amiga - Parallel port platform device conversion
> [14] rtc: Add an RTC driver for the Oki MSM6242
> [15] rtc: Add an RTC driver for the Ricoh RP5C01
> [16] m68k: amiga - RTC platform device conversion
>
> Due to lack of hardware (only Amiga 4000 here), I couldn't test all drivers.
> Especially the SCSI drivers could use some testing feedback.
> The changes to most other drivers are fairly trivial.

I'm a bit reluctant to apply the A3000 SCSI platform device conversion without
having received any feedback, and I would like to apply the whole series ASAP.
Did anyone try on A3000/A3000T? Similar changes are needed to convert the
A2091 and GVP II SCSI drivers to the zorro_driver model, so if we have
more users
of those, I can do that conversion first, so it can receive some testing.

Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
