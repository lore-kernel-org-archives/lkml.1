Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbXDCDv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbXDCDv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 23:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbXDCDvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 23:51:25 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58795
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbXDCDvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 23:51:25 -0400
From: Rob Landley <rob@landley.net>
To: Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Powerpc build unhappy in 2.6.20.4?
Date: Mon, 2 Apr 2007 23:51:09 -0400
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200703301753.27379.rob@landley.net> <200704021514.14681.rob@landley.net> <20070403005156.GN12768@bakeyournoodle.com>
In-Reply-To: <20070403005156.GN12768@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704022351.10343.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 8:51 pm, Tony Breeds wrote:
> On Mon, Apr 02, 2007 at 03:14:14PM -0400, Rob Landley wrote:
>  
> > Sure, quite easily the source of the trouble.  Attached in both 
full .config 
> > and mini.config formats.
> 
> Okay, I have no idea how it happend but you seem to have an invalid
> config.  It looks to me like you need to select a platform.

So "make oldconfig ARCH=powerpc" will accept a config that doesn't have a 
platform selected?

> One of the following:
> 	CONFIG_PPC_PSERIES
> 	CONFIG_PPC_MAPLE
> 	CONFIG_PPC_IBM_CELL_BLADE
> 	CONFIG_PPC_PS3
> 	CONFIG_PPC_CHRP
> 	CONFIG_PPC_EFIKA
> 	CONFIG_PPC_PMAC

Hmmm...  So CONFIG_PPC_MULTIPLATFORM doesn't cover it?  ("There is no help 
available for this kernel option"...  Maybe a website somewhere?)

I just ran "make oldconfig" again and it didn't complain about any of those 
not being set...

> When did this config last build a zImage?  I'm guessing either CHRP or
> PMAC?

Er, never.  I was largely guessing at what I needed via menuconfig.  (I'm 
trying to get something I can boot to a shell prompt under QEMU.)

I'll try this CHRP thing...

Thanks,

Rob
-- 
Penguicon 5.0 Apr 20-22, Linux Expo/SF Convention.  Bruce Schneier, Christine 
Peterson, Steve Jackson, Randy Milholland, Elizabeth Bear, Charlie Stross...
