Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab0BJNGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:06:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab0BJNGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:06:18 -0500
Date: Wed, 10 Feb 2010 14:06:16 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Michael Poole <mdpoole@troilus.org>
Cc: linux-input@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add a device driver for the Apple Magic Mouse.
In-Reply-To: <87pr4eeemz.fsf_-_@troilus.org>
Message-ID: <alpine.LNX.2.00.1002101404210.30967@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <dd18b0c31002082322m4238a4a6m73fc30752ba30447@mail.gmail.com> <1265710460.2383.5685.camel@localhost.localdomain> <201002090736.55576.edt@aei.ca> <alpine.LNX.2.00.1002091339190.30967@pobox.suse.cz>
 <87y6j2eeqv.fsf_-_@troilus.org> <87pr4eeemz.fsf_-_@troilus.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Feb 2010, Michael Poole wrote:

> >From da3e2b0330fccd584ad79495853e638e9652155b Mon Sep 17 00:00:00 2001
> From: Michael Poole <mdpoole@troilus.org>
> Date: Sat, 6 Feb 2010 12:24:36 -0500
> Subject: Add a device driver for the Apple Magic Mouse.
> 
> Signed-off-by: Michael Poole <mdpoole@troilus.org>
> ---
>  drivers/hid/Kconfig          |   10 +
>  drivers/hid/Makefile         |    1 +
>  drivers/hid/hid-core.c       |    1 +
>  drivers/hid/hid-ids.h        |    1 +
>  drivers/hid/hid-magicmouse.c |  469 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 482 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hid/hid-magicmouse.c
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 24d90ea..ba14ec8 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -183,6 +183,16 @@ config LOGIRUMBLEPAD2_FF
>  	  Say Y here if you want to enable force feedback support for Logitech
>  	  Rumblepad 2 devices.
>  
> +config HID_MAGICMOUSE
> +	tristate "Apple" if EMBEDDED

Could you please make this something else than "Apple"? This string is 
already used by HID_APPLE.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
