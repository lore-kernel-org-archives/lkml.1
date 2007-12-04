Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901AbXLDIX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbXLDIX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXLDIXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:23:52 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35932
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbXLDIXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:23:51 -0500
Date: Tue, 04 Dec 2007 00:23:50 -0800 (PST)
Message-Id: <20071204.002350.93835897.davem@davemloft.net>
To: ben.collins@ubuntu.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [SPARC64] Export symbols for sunvnet and sunvdc to be built
 modular
From: David Miller <davem@davemloft.net>
In-Reply-To: <1196373730.13800.2.camel@cunning>
References: <1196373730.13800.2.camel@cunning>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Collins <ben.collins@ubuntu.com>
Date: Thu, 29 Nov 2007 17:02:10 -0500

> Fixes this build failure:
>     
> ERROR: "vio_driver_init" [drivers/net/sunvnet.ko] undefined!
> ERROR: "vio_driver_init" [drivers/block/sunvdc.ko] undefined!
> ERROR: "ldc_map_sg" [drivers/block/sunvdc.ko] undefined!
>     
> Signed-off-by: Ben Collins <bcollins@ubuntu.com>

Please check what you are patching against.

Every 2.6.x tree I have access to has these exports in
the precise locations you are adding them.

I suspect you have some local change intergration issue
in the tree where you encountered this build error.
