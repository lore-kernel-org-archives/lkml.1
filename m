Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbXEZWS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbXEZWS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbXEZWSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:18:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:46479 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXEZWSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:18:21 -0400
Subject: Re: [patch 1/7] ps3: Preallocate bootmem memory for the PS3 FLASH
	ROM storage driver
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.62.0705261050140.2657@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com>
	 <20070525083632.177254000@sonycom.com>
	 <1180132539.19517.2.camel@localhost.localdomain>
	 <Pine.LNX.4.62.0705261050140.2657@pademelon.sonytel.be>
Content-Type: text/plain
Date: Sun, 27 May 2007 08:17:50 +1000
Message-Id: <1180217870.19517.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-26 at 10:51 +0200, Geert Uytterhoeven wrote:
> 
> I know.
> 
> Do you know another way to allocate an aligned chunk of 256 KiB of
> physically
> contiguous memory, possibly a long time after boot up?

kmalloc & a good prayer ? :-0

Ben.


