Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbYAIEJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbYAIEJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 23:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbYAIEJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 23:09:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34265 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbYAIEJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 23:09:07 -0500
Date: Wed, 9 Jan 2008 05:11:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Dave Airlie <airlied@linux.ie>
Cc: Kevin Winchester <kjwinchester@gmail.com>, dri-devel@lists.sourceforge.net,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch 1/1] Convert drivers in drivers/char/drm to use .unlocked_ioctl
Message-ID: <20080109041135.GA7130@one.firstfloor.org>
References: <20080109005416.039551758@gmail.com> <20080109005443.227306069@gmail.com> <alpine.DEB.0.82.0801090336000.9570@skynet.skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0801090336000.9570@skynet.skynet.ie>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 03:37:50AM +0000, Dave Airlie wrote:
> 
> > The drm drivers in this patch all used drm_ioctl to perform their
> > ioctl calls.  The common function is converted to use lock_kernel()
> > and unlock_kernel() and the drivers are converted to use .unlocked_ioctl
> > 
> 
> NAK

Did you actually read Kevin's patch? 

> 
> I've started looking at this already in the drm git tree, I'm going to 
> provide both locked and unlocked paths for drivers to choose, as we need 

If you do that you'll exactly need Kevin's patch as a base.

-Andi
