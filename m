Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZHNVFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZHNVFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbZHNVFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:05:17 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:58071 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754722AbZHNVFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:05:16 -0400
Date: Fri, 14 Aug 2009 17:05:17 -0400
To: Pander <pander@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] charger: Offer kernel build that disables disks, screen,
	etc. and lets laptop serve as charger for USB/FireWire devices
Message-ID: <20090814210517.GA3445@csclub.uwaterloo.ca>
References: <4A855F5D.1010502@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A855F5D.1010502@users.sourceforge.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 02:58:05PM +0200, Pander wrote:
> Consider situations where normal power outlets are not available, e.g.
> when travelling in remote areas or in an air plane or train, but you do
> need to charge USB/FireWire devices like a mobile telephone, camera,
> PDA, etc. It would be efficient to boot your laptop with a special
> kernel that turns it into a charger.
> 
> Some laptops already offer this feature, however the majority of laptops
> donot. A suspended laptop can offer this too, but please consider
> situation orplaces where power is so scarce that normally booting a
> laptop in order tocharge another device is undesirable in terms of being
> efficient with theenergy stored in the battery or that it is not allowed
> to activate RF devicesas is in an air plane.
> 
> Normal boot will cause that a lot of power will be consumed by the
> disks,screen, CPUs, RF devices, fans, all LEDs (except the one
> indicating the deviceis switched on), etc. while you are only interested
> in power being available at the USB/FireWire ports.
> 
> This can be achieved by building a special kernel that will shut down
> all hardware that is not needed for offering power on the before
> mentioned ports. Perhaps this can be achieved by kernel configuration
> alone or it might require a minimal of functionality to put a laptop
> into such a charging state.
> 
> Normally, systems automatically shut down before the battery is drained
> 100%. This kernel will allow you to drain all the entire battery.
> 
> The resulting kernel can be installed and made available in a similar
> way as the memtest kernel and can be incorporated by installers of
> GNU/Linux distributions.
> 
> Implementing this idea will allow for highly energy efficient recharging
> of devices like telephones, cameras and other mobile devices via your
> laptop.

Perhaps using your laptop is a charger is simply inefficient and no
matter how simple the system is it is likely to use way more power than
any dedicated usb charger would, and certainly more than the laptops
that actually support this in hardware.

-- 
Len Sorensen
