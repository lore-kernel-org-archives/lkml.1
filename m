Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYGNOR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYGNOR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbYGNORs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:17:48 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:59340 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbYGNORs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:17:48 -0400
Message-ID: <487B6004.6090801@inria.fr>
Date: Mon, 14 Jul 2008 16:17:40 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Maciej Sosnowski <maciej.sosnowski@intel.com>
CC: dan.j.williams@intel.com, shannon.nelson@intel.com,
       linux-kernel@vger.kernel.org, net-dev@vger.kernel.org
Subject: Re: [PATCH 1/2] I/OAT: Add watchdog/reset functionality to ioatdma
 driver
References: <20080714132215.26830.90819.stgit@linux.site> <20080714132349.26830.22215.stgit@linux.site>
In-Reply-To: <20080714132349.26830.22215.stgit@linux.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Sosnowski wrote:
> Due to occasional DMA channel hangs observed for I/OAT versions 1.2 and 2.0
> a watchdog has been introduced to check every 2 seconds
> if all channels progress normally.
> If stuck channel is detected, driver resets it.
> The reset is done in two parts. The second part is scheduled 
> by the first one to reinitialize the channel after the restart.
>   

Is all this transparent to the caller? Are you reposting all copies to
the hardware after the reset? Or are we going to get some DMA_ERROR
return values ?

> Sleep time in self_test has been increased to 10ms
> since in some cases 1ms appeared not to be enough

Thanks Maciej, this helps a lot here.

Brice

