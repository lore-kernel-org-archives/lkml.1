Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbYE2Ngp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbYE2Ngp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbYE2Nga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:36:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:45297 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbYE2Ng3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:36:29 -0400
Date: Thu, 29 May 2008 15:39:21 +0200
From: Holger Macht <hmacht@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
Message-ID: <20080529133921.GB9268@homac.suse.de>
Mail-Followup-To: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
	linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
	linux-acpi@vger.kernel.org, akpm@linux-foundation.org
References: <20080528143857.GB5585@homac.suse.de> <20080529132253.GA22309@srcf.ucam.org> <20080529133302.GA9268@homac.suse.de> <20080529133201.GA22476@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529133201.GA22476@srcf.ucam.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 29. May - 14:32:01, Matthew Garrett wrote:
> On Thu, May 29, 2008 at 03:33:02PM +0200, Holger Macht wrote:
> 
> > Can you please give a bit more details? Does your userspace react on the
> > eject request? I tested with Thinkpads, too.
> 
> No, I'm not doing anything with userspace - just pulling the drive out 
> directly. I'm looking into it now.

This was one of my test scenarios. Just a hint for debugging, before my
patch, HAL accessed /dev/sr0 directly after removing the device, and that
caused the lockup. Hopefully that doesn't bite us again...

 - Holger
