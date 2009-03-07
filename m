Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZCGH13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZCGH13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 02:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZCGH1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 02:27:20 -0500
Received: from mx3.mail.ru ([94.100.176.17]:32005 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZCGH1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 02:27:19 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
To: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Sat, 07 Mar 2009 10:27:09 +0300
References: <20090306003941.GA32403@srcf.ucam.org> <20090306005234.GA32539@srcf.ucam.org>
User-Agent: KNode/0.99.01
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LfqwF-000B1G-00.arvidjaar-mail-ru@mx3.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:

> +	{KE_KEY, 0x13d, KEY_SLEEP},
> +	{KE_KEY, 0x13e, KEY_SUSPEND},

I have two buttons marked with memory and disk pictures. When I press the 
first one HAL emits "sleep" button event, for the the second one HAL emits 
"hibernate" event. I am using KDE4 and neither works :) According to KDE4 
developer, they implement "suspend" button as suspend to RAM. Just trying to 
clarify which key this should be and whether HAL should be fixed.  (I opened 
bug report for KDE4)

> +	{KE_KEY, 0x13f, KEY_SWITCHVIDEOMODE},

I wonder, who is supposed to act upon it? Is there any generic user space 
agent who implements video output switching?

> +	{KE_KEY, 0x140, KEY_BRIGHTNESSDOWN},
> +	{KE_KEY, 0x141, KEY_BRIGHTNESSUP},
> +	{KE_KEY, 0x142, KEY_WLAN},

Ditto. Theoretically Toshiba even supports turning off radio via HCI, but it 
is again not clear who should actually initiate it.

