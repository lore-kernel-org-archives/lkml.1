Return-Path: <linux-kernel-owner+w=401wt.eu-S1758047AbYGGVCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047AbYGGVCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbYGGVCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:02:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37796 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbYGGVCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:02:41 -0400
Date: Mon, 7 Jul 2008 18:02:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: linux-dvb@linuxtv.org, Jaswinder Singh <jaswinder@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [linux-dvb] [PATCH] Remove fdump tool for av7110 firmware
Message-ID: <20080707180222.4b4a53a9@gaivota>
In-Reply-To: <200807060315.51736@orion.escape-edv.de>
References: <1214139259.2994.8.camel@jaswinder.satnam>
	<200807060315.51736@orion.escape-edv.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

> @Mauro:
> Is there a way to strip this stuff from Kconfig/Makefile/av7110*.[ch]
> for submission to the kernel? Basically I don't care whether and how
> they cripple the driver in the kernel. But I would like to keep the code
> 'as is' in the linuxtv repositories.

Having a binary firmware inside a GPL'd file seems to be (at least for some
people) a GPL violation, since the firmware source code should also be released
with GPL (please read [1] for a good article about this).

This seems to be one of the reasons for moving all firmwares that are still in
kernel into a separate dir. A latter step seems to move those files to a cousin
tree, hosted together with kernel tree, and clearly stating that those
firmwares are not GPL, but are allowed to be used with Linux. 

IANAL, but, if the firmware is violating GPL at Kernel, the same violation also
affects our tree. So, from legal POV, I think we ought to do the same thing at
V4L/DVB. 

Probably, it is safe to keep the firmware files into a separate dir,
if we state clearly that the firmwares are not GPL.

Anyway, let's see how we can handle it after having those patches merged at
mainstream.

[1] http://lwn.net/Articles/284932/

Cheers,
Mauro
