Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYGORmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYGORmy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYGORmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:42:46 -0400
Received: from bu3sch.de ([62.75.166.246]:37543 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbYGORmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:42:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add dynamic MMC-over-SPI-GPIO driver
Date: Tue, 15 Jul 2008 19:42:13 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
References: <200807142109.19360.mb@bu3sch.de>
In-Reply-To: <200807142109.19360.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807151942.13979.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2008 21:09:18 Michael Buesch wrote:
> This driver provides a sysfs interface to dynamically create
> and destroy GPIO-based MMC/SD card interfaces.
> So an MMC or SD card can be connected to generic GPIO pins
> and be configured dynamically from userspace.

Ok, I had requests in private to also allow registering the platform
device from outside of the module (and use platform data). This is
used for certain embedded hardware from the arch
code to statically create a GPIO-based MMC device.
I'll add that and resend along with the proposed fixes.
Thanks for the review! :)


-- 
Greetings Michael.
