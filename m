Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbZIKO0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbZIKO0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZIKO0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:26:34 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:43442 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbZIKO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=ZOobHief9X4WVxeVe1HA07u2sLjvuGE2HA2aYmLa78JL6gdKsXjTrGmw3h4J8Fc5Oe
         WRMGaG7krmjoy0WOfbAPcPWB1xYdJGYl1ptQEPeEJkclUgRZib/6ubYwc0UTOGGqQSoK
         OGfIhdyLeQMF+fMqwCwqtM3X9qNHn/msUI9Ig=
MIME-Version: 1.0
Date: Fri, 11 Sep 2009 16:26:36 +0200
X-Google-Sender-Auth: 6f8833cf9556df05
Message-ID: <10f740e80909110726x313e3e3coe2321c683163e3a5@mail.gmail.com>
Subject: drivers/staging/vme/Kconfig:5:warning: type of 'VME' redefined from 
	'boolean' to 'tristate'
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

http://kisskb.ellerman.id.au/kisskb/buildresult/1221192/:
drivers/staging/vme/Kconfig:5:warning: type of 'VME' redefined from
'boolean' to 'tristate'
drivers/staging/vme/Kconfig:5:warning: type of 'VME' redefined from
'boolean' to 'tristate'

We already have:

arch/m68k/Kconfig:config VME
arch/m68k/Kconfig:      bool "VME (Motorola and BVM) support"
arch/m68k/Kconfig:        Say Y here if you want to build a kernel for
a 680x0 based VME
arch/m68k/Kconfig:      depends on VME
arch/m68k/Kconfig:        Say Y to include support for early Motorola
VME boards.  This will
arch/m68k/Kconfig:      depends on VME
arch/m68k/Kconfig:        Say Y to include support for Motorola VME
boards.  This will build a
arch/m68k/Kconfig:      depends on VME
arch/m68k/Kconfig:        Say Y to include support for VME boards from
BVM Ltd.  This will
arch/m68k/Kconfig:      depends on (AMIGA || ATARI || MAC || SUN3 ||
SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_SCC=y || AT
fs/partitions/Kconfig:  default y if VME

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
