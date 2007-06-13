Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbXFMK3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbXFMK3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 06:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757251AbXFMK3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 06:29:41 -0400
Received: from styx.suse.cz ([82.119.242.94]:60772 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757497AbXFMK3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 06:29:39 -0400
Date: Wed, 13 Jun 2007 12:29:22 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Stanislav Brabec <sbrabec@suse.cz>
Subject: Re: Proposal: change keycode for scancode e0 32 from 150 to 172
Message-ID: <20070613102922.GE19888@suse.cz>
References: <466F1462.5090008@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466F1462.5090008@hhs.nl>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 11:47:14PM +0200, Hans de Goede wrote:
> Hi all,
> 
> As some of you might know from my earlier post/thread about atkbd and 
> softraw, I'm currently working on getting keyboards with internet/easy 
> access keys to work painlessly / plug and play.
> 
> In order to be able to better test / develop this I've bought 2 cheap such 
> keyboards today, one ps2 and one both usb and ps2 capable.
> 
> When comparing usb vs ps2 / testing the keycodes generated for the easy 
> access
> keys on my trust (microsoft compatible) keyboard. I noticed the homepage 
> key sends keycode 150 with ps2 and 172 with USB, or for those who don't 
> know the keycodes by head with ps2 it sends KEY_WWW and with usb it sends 
> KEY_HOMEPAGE
> 
> I personally believe that the usb behaviour is correct and that the ps/2 
> code should be modified to match for consistency. The ps/2 scancode to 
> keycode mapping is set up to handle easy access / internet keys for 
> microsoft compatible keyboards. So what is the right code to send here, 
> tricky, see:
> http://www.s2.com.br/s2arquivos/361/Imagens/555Image.jpg
> http://www.keyboardco.com/keyboard_images/microsoft_ergonomic_keyboard_4000_black_usb_large.jpg
> 
> The logo on the key is a homepage logo, the text below is www/homepage. So 
> what to send? I believe that for consistency with the usb codes send it 
> should be KEY_HOMEPAGE, but thats based on a sample of 1 usb keyboard. 
> Input on what other usb keyboards send for the key with the homepage iocn 
> is very much welcome.

KEY_HOMEPAGE is likely correct. Maybe we don't want to have KEY_WWW at
all, since it seems to be redundant.

-- 
Vojtech Pavlik
Director SuSE Labs
