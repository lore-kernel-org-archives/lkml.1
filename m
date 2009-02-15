Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZBOJ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZBOJ2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 04:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbZBOJ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 04:28:23 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:38142 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZBOJ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 04:28:22 -0500
Date: Sun, 15 Feb 2009 10:30:14 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] docbook: split kernel-api, add device-drivers book
Message-ID: <20090215093014.GD29094@uranus.ravnborg.org>
References: <20090211162644.f3feb758.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090211162644.f3feb758.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 04:26:44PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> The kernel-api docbook was much larger than any of the others,
> so processing it took longer and needed some docbook extras in
> some cases, so split it into kernel-api (infrastructure etc.)
> and device drivers/device subsystems.  This allows these docbooks
> to be generated in parallel.  (This reduced the docbook processing
> time on my 4-proc system with make -j4 from about 5min:16sec to
> about 2min:01sec.)
> 
> The chapters that were moved from kernel-api to device-drivers are:
> 
> Driver Basics
> Device drivers infrastructure
> Parallel Port Devices
> Message-based devices
> Sound Devices
> 16x50 UART Driver
> Frame Buffer Library
> Input Subsystem
> Serial Peripheral Interface (SPI)
> I2C and SMBus Subsystem
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

I like the split, and I assume you will carry the patch in a Documentation tree?

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam
