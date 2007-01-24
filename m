Return-Path: <linux-kernel-owner+w=401wt.eu-S965446AbXAXIVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965446AbXAXIVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 03:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965224AbXAXIVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 03:21:06 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:59966 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965446AbXAXIVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 03:21:05 -0500
Date: Wed, 24 Jan 2007 09:21:02 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: identifying CONFIG variable typoes in the source tree
In-Reply-To: <Pine.LNX.4.64.0701231559090.3014@CPE00045a9c397f-CM001225dbafb6>
Message-ID: <Pine.LNX.4.62.0701240917530.30467@pademelon.sonytel.be>
References: <Pine.LNX.4.64.0701231559090.3014@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007, Robert P. J. Day wrote:
>   let's check these:
> 
> $ grep -r 53C700_BE_BUS .
> ./drivers/scsi/53c700.h:#ifdef CONFIG_53C700_BE_BUS

This is the core support for big endian 53c700 SCSI busses. It's needed for
various m68k machines, patch to be submitted when the m68k support is ready for
submission.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
