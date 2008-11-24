Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbYKXTqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbYKXTqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbYKXTqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:46:34 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:58158 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbYKXTqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:46:34 -0500
Date: Mon, 24 Nov 2008 20:49:12 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: ben@simtec.co.uk, LKML <linux-kernel@vger.kernel.org>
Subject: Re: section mismatches with _sm501_register_gpio() and
	_sm501_gpio_register_chip()
Message-ID: <20081124194911.GC2604@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <8bd0f97a0811202013r170c9906i15797ca953844cff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0811202013r170c9906i15797ca953844cff@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Thu, Nov 20, 2008 at 11:13:31PM -0500, Mike Frysinger wrote:
> WARNING: drivers/mfd/built-in.o(.text+0x8d6): Section mismatch in
> reference from the function _sm501_register_gpio() to the function
> .devinit.text:_sm501_gpio_register_chip()
> The function _sm501_register_gpio() references
> the function __devinit _sm501_gpio_register_chip().
> This is often because _sm501_register_gpio lacks a __devinit
> annotation or the annotation of _sm501_gpio_register_chip is wrong.
> 
> WARNING: drivers/mfd/built-in.o(.text+0x90a): Section mismatch in
> reference from the function _sm501_register_gpio() to the function
> .devinit.text:_sm501_gpio_register_chip()
> The function _sm501_register_gpio() references
> the function __devinit _sm501_gpio_register_chip().
> This is often because _sm501_register_gpio lacks a __devinit
> annotation or the annotation of _sm501_gpio_register_chip is wrong.
Which kernel are you triggering this on ?

Cheers,
Samuel.



> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_CORE is not set
> CONFIG_MFD_SM501=y
> CONFIG_MFD_SM501_GPIO=y
> CONFIG_HTC_PASIC3=y
> CONFIG_UCB1400_CORE=m
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_WM8400 is not set
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> -mike

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
