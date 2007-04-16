Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028AbXDPGgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbXDPGgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbXDPGgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:36:17 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:45883 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbXDPGgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:36:16 -0400
Date: Mon, 16 Apr 2007 02:31:13 -0400
From: Kyle McMartin <kyle@parisc-linux.org>
To: David Miller <davem@davemloft.net>
Cc: kyle@parisc-linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: modalias support for of_device
Message-ID: <20070416063113.GG23783@athena.road.mcmartin.ca>
References: <20070416041933.GE23783@athena.road.mcmartin.ca> <20070415.220639.41635818.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415.220639.41635818.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 10:06:39PM -0700, David Miller wrote:
> How does this work?  Does some program walk through sysfs
> scanning the attributes of devices, and this triggers
> module matching?
>

As I understand it, the sysfs code will send a modalias event that
udev picks up. When depmod runs over the modules, it will generate a
device table (modules.ofmap) that udev will inspect to figure out which
module to load for the given of_device_id.

Cheers,
	Kyle M.
