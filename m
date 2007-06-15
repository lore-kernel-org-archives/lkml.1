Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbXFOI57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbXFOI57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 04:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXFOI5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 04:57:51 -0400
Received: from mail.atmel.fr ([81.80.104.162]:55571 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbXFOI5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 04:57:50 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 04:57:46 EDT
Message-ID: <46725287.7020702@rfo.atmel.com>
Date: Fri, 15 Jun 2007 10:49:11 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>
CC: linux-fbdev-devel@lists.sourceforge.net,
       Andrew Victor <andrew@sanpeople.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>
Subject: Re: [PATCH] atmel_lcdfb: Fix wrong line_length calculation
References: <1179511541.3811.16.camel@bender> <1181647677482-git-send-email-hskinnemoen@atmel.com>
In-Reply-To: <1181647677482-git-send-email-hskinnemoen@atmel.com>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Haavard Skinnemoen :
> As Jan Altenberg pointed out, line_length will always be 0 if
> bits_per_pixel < 8. Fix this and also make sure that we round up to
> the nearest byte.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
> I haven't tested this with any real program that uses the frame buffer,
> but fbset seems to report sane values for line_length:

Thank you Haavard.

I have a bigger patch for all the support for STN display (tested with
mono STN display). It is based on the work from Jan Altenberg.

This bigger patch includes your modifications.

I send it right now. As a separate message.

Haavard, can you check if the compute_hozval()
function is ok on avr32 (I have reviewed with the at32ap7000 and hope 
that it is ok) ?


Regards,
-- 
Nicolas Ferre


