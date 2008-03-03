Return-Path: <linux-kernel-owner+w=401wt.eu-S1758820AbYCCUpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820AbYCCUpC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:45:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYCCUox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:44:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:56397 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbYCCUow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:44:52 -0500
Subject: Re: [BUG/RFC/PATCH] drm: Fix for non-coherent DMA PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Gerhard Pircher <gerhard_pircher@gmx.net>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org
In-Reply-To: <20080303195117.7040@gmx.net>
References: <20071125234254.B4405DDE49@ozlabs.org>
	 <20080302110505.175270@gmx.net> <1204490829.15052.482.camel@pasglop>
	 <20080302223012.90210@gmx.net> <1204498569.15052.488.camel@pasglop>
	 <20080303195117.7040@gmx.net>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 07:44:11 +1100
Message-Id: <1204577051.21545.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-03-03 at 20:51 +0100, Gerhard Pircher wrote:
> > Remove the GFP_HIGHMEM from the above. It looks like our cache
> > flushing isn't going to work for highmem, it would need some
> > kmap's for that.

> Yes, it looks like this was the problem. No kernel oops anymore.
> The machine locks up anyway (which is a well known hardware problem).
> It doesn't lock up with CPPIOMode=true, but probably only because the
> initialization of DRI fails with "BAD cp_mode (f0000000)!".

Damn, I wonder why you insist trying to make that machine work :-) The
hardware is just totally busted.

Ben.


