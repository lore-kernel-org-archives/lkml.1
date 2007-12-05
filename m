Return-Path: <linux-kernel-owner+w=401wt.eu-S1756619AbXLGVVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbXLGVVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 16:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbXLGVV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 16:21:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1451 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753364AbXLGVVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 16:21:24 -0500
Date: Wed, 5 Dec 2007 11:13:53 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ata: ahci: Enclosure Management via LED
Message-ID: <20071205111352.GB3864@ucw.cz>
References: <20071129094802.49e729ed@appleyard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129094802.49e729ed@appleyard>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  
> +static int ahci_em_messages = 1;
> +module_param(ahci_em_messages, int, 0444);
> +/* add other LED protocol types when they become supported */
> +MODULE_PARM_DESC(ahci_em_messages,
> +	"Set AHCI Enclosure Management Message type (0 = disabled, 1 = LED");

Should you add line in Doc* somewhere?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
