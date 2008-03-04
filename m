Return-Path: <linux-kernel-owner+w=401wt.eu-S935201AbYCDX4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935201AbYCDX4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934223AbYCDXz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:55:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37277 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934990AbYCDXz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:55:57 -0500
Date: Tue, 4 Mar 2008 15:52:14 -0800
From: Greg KH <greg@kroah.com>
To: rafa400@losgandia.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: NUDAM (USB-485) nowaday not detected by pl2303 module
Message-ID: <20080304235214.GC3773@kroah.com>
References: <26349.208.97.187.133.1204650893.squirrel@mail.losgandia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26349.208.97.187.133.1204650893.squirrel@mail.losgandia.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 09:14:53AM -0800, rafa400@losgandia.com wrote:
> [1.] new NUDAM (USB-485) converter not recogniced by pl2303. Little change
> required.
> [2.] Until now NUDAM USB to RS-485/422 RS232 converter was detected by USB
> system and pl2303 module working fine in my Debian as /dev/ttyUSB0
> 
> # dmesg
> ....
> usb 5-1.3: new full speed USB device using ehci_hcd and address 17
> usb 5-1.3: configuration #1 chosen from 1 choice
> pl2303 5-1.3:1.0: pl2303 converter detected
> usb 5-1.3: pl2303 converter now attached to ttyUSB0
> 
> # lsusb
> Bus 005 Device 017: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
> 
>  They changed USB ID and now its like:
> 
> # lsusb
> Bus 005 Device 016: ID 0b63:6530 ADLink Technology, Inc.
> 
> but this ID is not detected by PD2303 module.
> a little change in pl2303 solve the problem

Are you sure that the chip is still a pl2303 device?  If so, can you
send us a patch for this device id as per the
Documentation/SubmittingPatches directions?

thanks,

greg k-h
