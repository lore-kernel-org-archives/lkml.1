Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbZC3HWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbZC3HWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbZC3HWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:22:01 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:33652 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZC3HWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:22:00 -0400
Date: Mon, 30 Mar 2009 09:21:55 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: comedi doesn't like the new irqreturn_t
Message-ID: <Pine.LNX.4.64.0903300919540.19172@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k:
| In file included from drivers/staging/comedi/comedidev.h:40,
|                  from drivers/staging/comedi/comedi_fops.c:45:
| drivers/staging/comedi/interrupt.h:30:1: warning: "IRQ_RETVAL" redefined
| In file included from include/linux/interrupt.h:10,
|                  from drivers/staging/comedi/interrupt.h:22,
|                  from drivers/staging/comedi/comedidev.h:40,
|                  from drivers/staging/comedi/comedi_fops.c:45:
| include/linux/irqreturn.h:15:1: warning: this is the location of the previous definition
| In file included from drivers/staging/comedi/comedidev.h:41,
|                  from drivers/staging/comedi/comedi_fops.c:46:
| drivers/staging/comedi/interrupt.h:27: error: conflicting types for 'irqreturn_t'
| include/linux/irqreturn.h:14: error: previous declaration of 'irqreturn_t' was here
| make[6]: *** [drivers/staging/comedi/comedi_fops.o] Error 1

I suspect a similar problem with drivers/staging/otus, but that one isn't
compiled on m68k due to its dependency on USB.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
