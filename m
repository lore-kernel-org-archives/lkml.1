Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbXDPAgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbXDPAgP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 20:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbXDPAgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 20:36:15 -0400
Received: from lazybastard.de ([212.112.238.170]:43518 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbXDPAgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 20:36:14 -0400
Date: Mon, 16 Apr 2007 02:31:48 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [RFC] MTD driver for MMC cards
Message-ID: <20070416003148.GA23559@lazybastard.org>
References: <200612281418.20643.arnd@arndb.de> <200701012322.14735.arnd@arndb.de> <459CB001.4010800@drzeus.cx> <200704160133.18597.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704160133.18597.arnd@arndb.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 April 2007 01:33:17 +0200, Arnd Bergmann wrote:
> 
> There is also still some need for performance testing. Jörn
> brought up the point that if a specific card can't have multiple
> open erase block simulateously, it's rather pointless for
> logfs. It might still be useful to use jffs2 on those cards,
> because IFAIK that only writes to one erase block at any
> time.

This appears to be a problem for practically all consumer-available
flash media.  They spend a lot of effort trying to hide any flash
properties from their users.  And while this is a decent strategy for
FAT, ext3, ntfs and similar, it is actually very inefficient for a flash
filesystem.

After talking to several manufacturers, most seemed to be fairly
open-minded towards supporting an alternate interface with raw flash
access.  So much for the good news.  Bad news is that such an elternate
interface still needs to be defined.

Jörn

-- 
Courage is not the absence of fear, but rather the judgement that
something else is more important than fear.
-- Ambrose Redmoon
