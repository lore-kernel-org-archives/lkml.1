Return-Path: <linux-kernel-owner+w=401wt.eu-S1030346AbXEAKdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346AbXEAKdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031144AbXEAKdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:33:41 -0400
Received: from outmail1.freedom2surf.net ([194.106.33.237]:37514 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030346AbXEAKdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:33:40 -0400
Subject: Re: [RFC, PATCH 0/4] SoC base drivers
From: ian <spyro@f2s.com>
To: Ben Dooks <ben-linux-arm@fluff.org>
Cc: Paul Sokolovsky <pmiscml@gmail.com>, kernel-discuss@handhelds.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20070501083900.GL5875@trinity.fluff.org>
References: <1354376306.20070501080806@gmail.com>
	 <20070501083900.GL5875@trinity.fluff.org>
Content-Type: text/plain
Date: Tue, 01 May 2007 11:33:27 +0100
Message-Id: <1178015607.12995.9.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 09:39 +0100, Ben Dooks wrote:
> 
> Wow, platform devices with a new name. I don't see how any of this is
> not handled by platfrom device.

No, not so. That was a criticism levelled at a previous incarnation of
this code which has since been addressed - this is now a convienience
layer on top of platform device, as opposed to what it used to be - a
complete device class of its own.

It eliminates a _lot_ of code duplication for hh.org, where we have
multiple machines with multiple CPU types all sharing multiple SoC chips
which have varying subsets of decices in them (eg. the TMIO SoCs share
MMC blocks with the ASIC3 ones, w1 is shared in a few devices, etc.)

> Anything registering new IRQs could create sub platform devices
> with the correct resources.

Which is exactly what this code does, but without requiring each and
every platform to rewrite the same glue code over and over.

