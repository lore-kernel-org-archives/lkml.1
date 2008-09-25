Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYIYTji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYIYTji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYIYTja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:39:30 -0400
Received: from styx.suse.cz ([82.119.242.94]:56254 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753371AbYIYTj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:39:29 -0400
Date: Thu, 25 Sep 2008 22:35:58 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Frans Pop <elendil@planet.nl>, airlied@gmail.com,
       Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>,
       jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <200809251236.12287.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LNX.1.10.0809252234400.3389@pegasus.suse.cz>
References: <20080923.150722.141587696.davem@davemloft.net> <200809251156.10648.jbarnes@virtuousgeek.org> <alpine.LNX.1.10.0809252218470.3389@pegasus.suse.cz> <200809251236.12287.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, Jesse Barnes wrote:

> However, the "Factory" log at #425480 *does* indicate that a GEM aware 
> 2D driver was loaded (the "[drm:i915_getparam] *ERROR* Unknown parameter 
> 5" message indicates as much), but the kernel was definitely not GEM 
> aware otherwise the call would have succeeded.  So that rules out GEM 
> proper, but it could still be a bug in one of the non-GEM paths in the 
> experimental xf86-video-intel bits the various distros seem to be 
> picking up.

That was exactly the point I was trying to make, that these error paths 
will probably also need auditing, once we rule out the possibility of 
NVRAM being overwritten from kernelspace.

Thanks,

-- 
Jiri Kosina
SUSE Labs
