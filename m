Return-Path: <linux-kernel-owner+w=401wt.eu-S933643AbXCEVib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933643AbXCEVib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933636AbXCEViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 16:38:05 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4529 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933633AbXCEViB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 16:38:01 -0500
Date: Tue, 1 Jan 2002 02:53:24 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Tommi Kyntola <tommi.kyntola@ray.fi>
Cc: linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
Subject: Re: [PATCH] acpi: fan after suspend-to-mem fix
Message-ID: <20020101025323.GA4106@ucw.cz>
References: <45E57A08.5060403@ray.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E57A08.5060403@ray.fi>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The fan hasn't worked on my HP nw8000 laptop after an S3 
> suspend
> ever, but fixing that to ACPI_D3 there finally makes it 
> work as
> expected.
> 
> If there was some hidden reason why that was set to 
> ACPI_D0,

You do not want to overheat while suspending.

(Yep, I'm doing some time travel in my spare time, sorry about that).


> @@ -243,7 +243,7 @@ static int acpi_fan_suspend(struct 
> acpi_device *device, int state)
>         if (!device)
>                 return -EINVAL;
> 
> -       acpi_bus_set_power(device->handle, 
> ACPI_STATE_D0);
> +       acpi_bus_set_power(device->handle, 
> ACPI_STATE_D3);
> 
>         return AE_OK;
>  }
> 
> -
> To unsubscribe from this list: send the line 
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
