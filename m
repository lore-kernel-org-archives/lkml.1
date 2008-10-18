Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbYJRUzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbYJRUzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYJRUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:55:47 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:34246 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbYJRUzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:55:46 -0400
Date: Sat, 18 Oct 2008 22:55:41 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 14/23] Staging: add w35und wifi driver
In-Reply-To: <1223678567-30143-14-git-send-email-greg@kroah.com>
Message-ID: <Pine.LNX.4.64.0810182017150.11796@anakin>
References: <20081010224130.GA30117@kroah.com> <1223678567-30143-14-git-send-email-greg@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008, Greg KH wrote:
> From: Pavel Machek <pavel@suse.cz>
> 
> This is driver for w35und usb wifi -- also in kohjinsha

> --- /dev/null
> +++ b/drivers/staging/winbond/Kconfig
> @@ -0,0 +1,7 @@
> +config W35UND
> +	tristate "Winbond driver"
> +	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL && !4KSTACKS
> +	default n
> +	---help---
> +	  This is highly experimental driver for winbond wifi card on some Kohjinsha notebooks
> +	  Check http://code.google.com/p/winbondport/ for new version

W35UND should depend on USB

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/winbond/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/winbond/Kconfig
+++ b/drivers/staging/winbond/Kconfig
@@ -1,6 +1,6 @@
 config W35UND
 	tristate "Winbond driver"
-	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL && !4KSTACKS
+	depends on MAC80211 && WLAN_80211 && USB && EXPERIMENTAL && !4KSTACKS
 	default n
 	---help---
 	  This is highly experimental driver for winbond wifi card on some Kohjinsha notebooks

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
