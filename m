Return-Path: <linux-kernel-owner+w=401wt.eu-S1760883AbXERSGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760883AbXERSGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 14:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755545AbXERSFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 14:05:55 -0400
Received: from www.osadl.org ([213.239.205.134]:34210 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752403AbXERSFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 14:05:54 -0400
Subject: Re: [Linux-fbdev-devel] [PATCH] atmel_lcdfb: AT91/AT32 LCD
	Controller framebuffer driver
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
In-Reply-To: <4641E1E2.6040808@rfo.atmel.com>
References: <463F3388.7020102@rfo.atmel.com>
	 <1178574017.4674.30.camel@daplas>  <4641E1E2.6040808@rfo.atmel.com>
Content-Type: text/plain
Date: Fri, 18 May 2007 20:05:31 +0200
Message-Id: <1179511541.3811.16.camel@bender>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

> +	info->fix.line_length = info->var.xres_virtual * (info->var.bits_per_pixel / 8);

line_length will always be 0 for bits_per_pixel < 8.

	Jan

