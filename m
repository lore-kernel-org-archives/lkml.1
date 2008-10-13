Return-Path: <linux-kernel-owner+w=401wt.eu-S1759498AbYJMQC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498AbYJMQC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758928AbYJMQCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:02:10 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:58170 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758849AbYJMQCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:02:08 -0400
Date: Mon, 13 Oct 2008 18:02:06 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
cc: linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Initial Console
In-Reply-To: <241b8f7b0810130520g1f8a2573v3261e24218546b75@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810131800510.30181@anakin>
References: <241b8f7b0810130520g1f8a2573v3261e24218546b75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Prabhu Chawandi wrote:
>    Initial console /dev/console in  the kernel is directed to /dev/ttyS0,

Depends...

> Any bosy is having info, where exavtly in which file has been done so..

drivers/char/tty_io.c, look for `TTYAUX_MAJOR, 1'.

> if not what exactly is happening to initialize console to ttyS0.

... depends on the list of available console devices, and the `console=' kernel
command line parameter.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
