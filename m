Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbYGGVUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbYGGVUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756067AbYGGVU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:20:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55191 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753445AbYGGVU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:20:27 -0400
Date: Mon, 7 Jul 2008 21:45:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Oliver Endriss <o.endriss@gmx.de>, linux-dvb@linuxtv.org,
       Jaswinder Singh <jaswinder@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
Message-ID: <20080707214537.49f69b51@the-village.bc.nu>
In-Reply-To: <20080707180222.4b4a53a9@gaivota>
References: <1214139259.2994.8.camel@jaswinder.satnam>
	<200807060315.51736@orion.escape-edv.de>
	<20080707180222.4b4a53a9@gaivota>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Having a binary firmware inside a GPL'd file seems to be (at least for some
> people) a GPL violation, since the firmware source code should also be released
> with GPL (please read [1] for a good article about this).

The firmware is usually a separate program, running on a separate
processor communicating by a standard API and is used by Linux, Windows
and other OS's. Thats not quite the same as say the Nvidia driver.

If it happens to keep the GPL zealots happier then fine, but there are
good sound technical reasons for doing it

- compiled in firmware isn't pageable
- compiled in firmware can't be updated separately
- it makes it really hard for end users told to "try the new firmware" -
especially in the enterprise space.

Clearly there are some cases that is less relevant - drivers where the
firmware/OS pair must match such as aic7xxx where you don't really want
firmware floating around loose.

Alan
