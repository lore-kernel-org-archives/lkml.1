Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbXDTCR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbXDTCR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 22:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbXDTCR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 22:17:28 -0400
Received: from web36703.mail.mud.yahoo.com ([209.191.85.37]:40315 "HELO
	web36703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754006AbXDTCR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 22:17:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=O26vUaNDw+cOms3lSZswcbMVkFM8E5USQ/g5tUKh4QLnGLuTn2xDXjwCxNZe/EDciBD20BWcIo/9LSi0UuUcP1aKiw/7jOAY5eoJULr0sk8Uu6arO3Wb/KpnMBuwHuv17Ve4BIFZmTmt+fJWDlxyI8EpDjsd9JifoljvdUhKUlk=;
X-YMail-OSG: ETJDsqEVM1nhb8dTzRmdIOkCeRdsHdS1eS4lkzOjOl3QvytejrNPf3kvH5EcYLwlNw--
Date: Thu, 19 Apr 2007 19:17:27 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
To: Sergey Yanovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
In-Reply-To: <4627D402.8020107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <204224.14405.qm@web36703.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Have you looked at the last version (0.8)? It fixed all outstanding issues (as far as I know).


--- Sergey Yanovich <ynvich@gmail.com> wrote:


---------------------------------
  Hi,

The device is present in many notebooks. Notebooks depend heavily onsuspend/resume functionality.
tifm_core/7xx1/sd family is an ambitous,but uncompleted project. It used to crash on resuming, or
hang up onsuspending. A less common failure used to be trigerred by a fast cardinsert/removal
sequence. Finally, tifm_sd module needs to be manuallyinserted.

I have found it easier to rewrite the driver, than to fix. This driveris kind of mutant. The bones
are taken from sdhci and omap, the meat -from tifm_*. It contains all features (and bugs except
named above) oftifm_* as it was in kernel 2.6.21-rc7.

I have been testing this version since linux-2.6.18 (daily readingphotos from cards, daily
suspending/resuming) without a single glitch.

This patch only provides sources.
[PATCH1/2] [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
Kernel configuration in this message.
[PATCH2/2] [mmc] alternative TIFM driver config for 2.6.21-rc7

Alex Dubov has done exceptionally great lots of work to teach linuxspeak to TIFM. This is just a
reorganization of his project.

The driver seems to be practically stable, but it definitely must betested by more people. Please
also report any issues with this driverto linux bug#8352 so that valuable info is not lost.

Best regards,
Sergey Yanovich



__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
