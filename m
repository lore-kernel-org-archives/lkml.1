Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYCJQ3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYCJQ3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYCJQ2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:28:54 -0400
Received: from mail.atmel.fr ([81.80.104.162]:47447 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbYCJQ2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:28:54 -0400
Message-ID: <47D5617E.3050800@atmel.com>
Date: Mon, 10 Mar 2008 17:27:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-fbdev-devel@lists.sourceforge.net,
       Linux Kernel list <linux-kernel@vger.kernel.org>
CC: "Antonino A. Daplas" <adaplas@gmail.com>,
       Sedji GAOUAOU <sedji.gaouaou@atmel.com>,
       Patrice VILCHEZ <patrice.vilchez@atmel.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [Linux-fbdev-devel] [PATCH] atmel_lcdfb: wiring BGR to RGB colormode
References: <47D5450A.40500@atmel.com>
In-Reply-To: <47D5450A.40500@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre :
> Adds different wiring mode for the LCD screen.
> 
> The legacy atmel LCDC IP uses a non standard color mode,
> "BGR-555.1" instead "RGB-565". The major part of graphic stacks 
> for embedded systems uses only "RGB-565". It is possible to swap 
> LCD IOs instead of doing this bit swapping by software (See 
> application note AT91SAM9 LCD Controller
> http://www.atmel.com/dyn/resources/prod_documents/doc6300.pdf)
> 
> This wire swapping is done on the at91sam9rl-ek board (board code 
> using this patch will come later).

Forgotten line :

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>


> ---
>  drivers/video/atmel_lcdfb.c |   27 ++++++++++++++++++++++-----
>  include/video/atmel_lcdc.h  |   10 ++++++++++
>  2 files changed, 32 insertions(+), 5 deletions(-)


-- 
Nicolas Ferre
