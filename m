Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbXDYOGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbXDYOGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 10:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbXDYOGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 10:06:31 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:44111 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082AbXDYOGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 10:06:30 -0400
Date: Wed, 25 Apr 2007 10:06:29 -0400
To: Peer Chen <pchen@nvidia.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
Subject: Re: [PATCH] drivers/net: move the nvidia forcedeth driver from 100M group to 1000M group
Message-ID: <20070425140629.GD5577@csclub.uwaterloo.ca>
References: <15F501D1A78BD343BE8F4D8DB854566B130752BE@hkemmail01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15F501D1A78BD343BE8F4D8DB854566B130752BE@hkemmail01.nvidia.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 01:30:04PM +0800, Peer Chen wrote:
> nForce ehternet is a Gigabit NIC not 100M, move it to 1000M group to
> avoid the confusion.

The forcedeth on my nforce2 board is 100Mbit.  I think the driver
handles both 100Mbit and GBit type devices.  Makes for an interesting
categorization problem.  Moving it would cause confusion.  Leaving it
where it is could cause confusion.  Moving it may confuse existing users
more though so I would recommend leaving it alone unless you can somehow
make it appear in both.

--
Len Sorensen
