Return-Path: <linux-kernel-owner+w=401wt.eu-S1751589AbYJRVTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbYJRVTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 17:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750976AbYJRVTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 17:19:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:54672 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbYJRVTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 17:19:10 -0400
Date: Sat, 18 Oct 2008 14:19:18 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       kaszak@gmail.com, lcostantino@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: w35und wifi driver for linux-staging
Message-ID: <20081018141918.2c7377c6@infradead.org>
In-Reply-To: <20081001123656.GA30942@elf.ucw.cz>
References: <20081001123656.GA30942@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 14:36:56 +0200
Pavel Machek <pavel@suse.cz> wrote:

> Hi!
> 
> This is driver for w35und usb wifi -- also in kohjinsha
> subnotebook. It should work well enough to associate and ping, but it
> obviously needs to be rewritten two more times...
> 
> OTOH worst horrors (like embedded wifi stack) should have been fixed
> already...

> diff --git a/drivers/net/wireless/winbond/Kconfig
> b/drivers/net/wireless/winbond/Kconfig new file mode 100644
> index 0000000..94499d3
> --- /dev/null
> +++ b/drivers/net/wireless/winbond/Kconfig
> @@ -0,0 +1,6 @@
> +config W35UND
> +	tristate "Winbond driver"
> +	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
> && !4KSTACKS

why this !4KSTACKS? At minimum that should be in the "to fix" list ;)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
