Return-Path: <linux-kernel-owner+w=401wt.eu-S1764997AbXEVCuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764997AbXEVCuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 22:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758228AbXEVCuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 22:50:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:51547 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757907AbXEVCt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 22:49:59 -0400
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Keith Packard <keithp@keithp.com>
Cc: Jesse Barnes <jesse.barnes@intel.com>,
       James Simmons <jsimmons@pentafluge.infradead.org>,
       dri-devel@lists.sourceforge.net, Dave Airlie <airlied@gmail.com>,
       linux-kernel@vger.kernel.org, "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <1179795093.5826.391.camel@neko.keithp.com>
References: <200705171423.46748.jesse.barnes@intel.com>
	 <1179792587.32247.769.camel@localhost.localdomain>
	 <1179795093.5826.391.camel@neko.keithp.com>
Content-Type: text/plain
Date: Tue, 22 May 2007 12:48:25 +1000
Message-Id: <1179802105.32247.780.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 17:51 -0700, Keith Packard wrote:
> 
> That's the plan; the kernel just provides mechanism. The architecture
> used in the X server splits precisely at this point with the mechanism
> in the driver and the configuration and policy up in the X server
> proper. Quite a bit of that code could be broken out into a shared
> library for fbdev-based apps and the X server to share, but that's
> down the road a bit after the kernel APIs look a lot more solid.

Ok, good plan then.

> With the goal of getting to a single-mode-set boot to avoid screen
> flashing before login, the key here is to make any early user-mode
> graphics apps share the same kernel graphics infrastructure as the X
> server to identify the common cases where the startup and X modes are
> the same and avoid resetting the configuration.

Ok. Fair enough.

Cheers,
Ben.


