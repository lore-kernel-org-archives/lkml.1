Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbXLDNyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbXLDNyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbXLDNyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:54:06 -0500
Received: from adelie.canonical.com ([91.189.90.139]:40105 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbXLDNyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:54:05 -0500
Subject: Re: [SPARC64] Export symbols for sunvnet and sunvdc to be built
	modular
From: Ben Collins <ben.collins@ubuntu.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071204.002350.93835897.davem@davemloft.net>
References: <1196373730.13800.2.camel@cunning>
	 <20071204.002350.93835897.davem@davemloft.net>
Content-Type: text/plain
Organization: Canonical
Date: Tue, 04 Dec 2007 08:54:03 -0500
Message-Id: <1196776443.5907.49.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-04 at 00:23 -0800, David Miller wrote:
> From: Ben Collins <ben.collins@ubuntu.com>
> Date: Thu, 29 Nov 2007 17:02:10 -0500
> 
> > Fixes this build failure:
> >     
> > ERROR: "vio_driver_init" [drivers/net/sunvnet.ko] undefined!
> > ERROR: "vio_driver_init" [drivers/block/sunvdc.ko] undefined!
> > ERROR: "ldc_map_sg" [drivers/block/sunvdc.ko] undefined!
> >     
> > Signed-off-by: Ben Collins <bcollins@ubuntu.com>
> 
> Please check what you are patching against.
> 
> Every 2.6.x tree I have access to has these exports in
> the precise locations you are adding them.
> 
> I suspect you have some local change intergration issue
> in the tree where you encountered this build error.

I was pretty sure I diff'd the tree I have against linux-2.6/master, but
maybe not.

Thanks

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/
SwissDisk: http://www.swissdisk.com/

