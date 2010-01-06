Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898Ab0AFOnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0AFOnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 09:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755878Ab0AFOnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 09:43:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42733 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871Ab0AFOnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 09:43:46 -0500
Date: Wed, 6 Jan 2010 08:41:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Christian Hofstaedtler <ch@zeha.at>, x86@kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
Message-ID: <20100106074101.GE1392@ucw.cz>
References: <20100104162114.GA30113@percival.namespace.at> <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> commit 2cb758c617833c18c533e1c4c31167e59d092235
> Author: Len Brown <len.brown@intel.com>
> Date:   Thu Nov 6 22:43:21 2008 -0500
> 
>     x86, ACPI: default to reboot via ACPI (again)
>     
>     We've run into systems which do not reboot properly
>     without using the ACPI reset mechanism.  So lets
>     try this in linux-next for a while and see
>     how many existing machines stop rebooting
>     because they can't handle ACPI reboot.

>     Signed-off-by: Len Brown <len.brown@intel.com>

Nak.

> @@ -32,7 +32,7 @@ EXPORT_SYMBOL(pm_power_off);
>  
>  static const struct desc_ptr no_idt = {};
>  static int reboot_mode;
> -enum reboot_type reboot_type = BOOT_KBD;
> +enum reboot_type reboot_type = BOOT_ACPI;
>  int reboot_force;
>  

KBD is present on all PCs, not so with acpi. If machine can't handle
kbd reboot, it is not IBM PC compatible.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
