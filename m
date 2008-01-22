Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbYAVWJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbYAVWJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYAVWJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:09:29 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58004 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYAVWJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:09:28 -0500
Date: Wed, 23 Jan 2008 00:08:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Wilco Beekhuizen <wilcobeekhuizen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Message-ID: <20080122220802.GI26556@does.not.exist>
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 08:18:32PM +0100, Wilco Beekhuizen wrote:

> 2.6.24-rc8 (possibly lower rc's too) has usb_find_device removed from
> usb.c. This causes problems when compiling modules that need
> usb_find_device.
> This patch puts the symbol back in place. Unless someone has a good
> reason not to include usb_find_device?
>...

The good reason is that there is no longer any in-kernel user of this 
export, and the kernel does not offer APIs only for external modules.

If there's no in-kernel users that's also a light indication that it 
might not be the correct API to use.

Tell the vendors of the modules using it that they should submit their 
modules for inclusion in the kernel.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

