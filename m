Return-Path: <linux-kernel-owner+w=401wt.eu-S1757460AbXJYVdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460AbXJYVdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXJYVcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:32:52 -0400
Received: from smtprelay08.ispgateway.de ([80.67.29.8]:45553 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbXJYVcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:32:52 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] ata: ahci: Enable enclosure management via LED (resend)
Date: Thu, 25 Oct 2007 23:35:11 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@linux-foundation.org, jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@openedhand.com>
References: <20071024155845.5129d6a4.kristen.c.accardi@intel.com>
In-Reply-To: <20071024155845.5129d6a4.kristen.c.accardi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710252335.12975.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kristen,

On Thursday 25 October 2007, Kristen Carlson Accardi wrote:
> Enable enclosure management via LED
> 
> As described in the AHCI spec, some AHCI controllers may support 
> Enclosure management via a variety of protocols.  This patch
> adds support for the LED message type that is specified in 
> AHCI 1.1 and higher.

Linux has a LED subsystem for that. May I suggest, that you just register
these leds and let userspace handle them via that via the LED API?

The LED userspace API is described in Documentation/leds-class.txt
and the headers for registering LEDs is linux/leds.h under include/

Since you explicitly WANT user space to control these, that should
be the right API. 

Richard, what do YOU think?


Best Regards

Ingo Oeser
