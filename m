Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbZJEIZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbZJEIZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758676AbZJEIZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:25:56 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:31254 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758675AbZJEIZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:25:54 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4AC9AD68.7060801@tremplin-utc.net>
Date: Mon, 05 Oct 2009 10:25:12 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20090830 Mandriva/2.0.0.23-2mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 try 2] LIS3LV02D I2C driver
References: <1254727478-19802-1-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1254727478-19802-1-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 05-10-09 09:24, Samu Onkalo schreef:
> These patches add I2C bus support for LIS3LV02D accelerometer driver
> and possibility to use platform configurability for
> remapping of device axes.
> 
> Changes are tested on linux-omap environment.
> Applies to 2.6.32-rc3.
Looks good,
Andrew, could you queue this series?

Thanks,
Eric


> 
> Samu Onkalo (2):
>   LIS3LV02D: axis remap and resource setup / release
>   LIS3LV02D: I2C support
> 
>  drivers/hwmon/Kconfig         |   17 ++++
>  drivers/hwmon/Makefile        |    1 +
>  drivers/hwmon/lis3lv02d_i2c.c |  184 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/lis3lv02d.h     |   12 +++
>  4 files changed, 214 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/lis3lv02d_i2c.c
> 

