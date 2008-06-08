Return-Path: <linux-kernel-owner+w=401wt.eu-S1755805AbYFHT5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbYFHT5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 15:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYFHT5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 15:57:08 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:59901 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbYFHT5H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 15:57:07 -0400
Date: Sun, 08 Jun 2008 21:57:04 +0200
Message-Id: <309319408@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, bunk@kernel.org
Subject: Re: [2.6 patch] MAINTAINERS: remove HGA FRAMEBUFFER DRIVER entry
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/MddP6bZaG2optWvm4cf7ItrlSFijhyXklqwAvGOj8yKZ1v
 smuK0TVgobKxdnbbOq2+zEiVisyx59ZaHO1kG/hDGKwK6xXmk0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no need for merging this one ?


List:       linux-kernel
Subject:    Re: [2.6 patch] MAINTAINERS: remove HGA FRAMEBUFFER DRIVER entry
From:       devzero () web ! de
Date:       2008-06-01 11:41:30
Message-ID: 299882843 () web ! de
[Download message RAW]

addon:

- the driver  has issues - see http://bugzilla.kernel.org/show_bug.cgi?id=9689
- after digging out author's recent email on the net and asking him, he confirmed, \
that he doesen`t maintain it anymore. he lost his hga hardware in 2001. also see \
bugzilla entry.

furthermore:

> hgafb: probe of hgafb.0 failed with error -22
> Device 'hgafb.0' does not have a release() function, it is broken and must be \
>                 fixed.
> WARNING: at drivers/base/core.c:107 device_release()

as that bug hasn't been touched since january and kernel telling that it`s broken, i \
think it also should  depend on BROKEN.



Acked-by: Roland Kletzing <devzero@web.de>


List:       linux-kernel
Subject:    [2.6 patch] MAINTAINERS: remove HGA FRAMEBUFFER DRIVER entry
From:       Adrian Bunk <bunk () kernel ! org>
Date:       2008-05-19 22:09:28
Message-ID: 20080519220928.GW17716 () cs181133002 ! pp ! htv ! fi
[Download message RAW]

- maintainer has not been active for years
- maintainer email bounces
- URL no longer exists
- covered by the FRAMEBUFFER LAYER entry

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
fc7a740aef47772e5417c71f52aa9726eb5c716d diff --git a/MAINTAINERS b/MAINTAINERS
index 2f74092..af69cab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1822,13 +1822,6 @@ M:	zippel@linux-m68k.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-HGA FRAMEBUFFER DRIVER
-P:	Ferenc Bakonyi
-M:	fero@drama.obuda.kando.hu
-L:	linux-nvidia@lists.surfsouth.com
-W:	http://drama.obuda.kando.hu/~fero/cgi-bin/hgafb.shtml
-S:	Maintained
-
 HID CORE LAYER
 P:	Jiri Kosina
 M:	jkosina@suse.cz
_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

