Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbYGYBJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbYGYBJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYGYBIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:08:52 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:2071 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020AbYGYBIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:08:51 -0400
Date: Thu, 24 Jul 2008 20:08:41 -0500 (CDT)
Message-Id: <200807250108.m6P18f4B099179@sullivan.realtime.net>
From: Milton Miller <miltonm@bga.com>
Subject: Re: [RFC,PATCH] scripts/package: add powerpc images to tarball
To: Jeremy Kerr <jk@ozlabs.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1216887460.306306.238738123378.1.gpush@pingu>
References: <1216887460.306306.238738123378.1.gpush@pingu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Currently, tarball builds for powerpc kernels don't have any boot
> images (other than vmlinux) present.
> 
> Add support for powerpc builds in the buildtar script, to include
> a few default images.
> 
> Signed-off-by: Jeremy Kerr <jk at ozlabs.org>
> 
> ---
> RFC: any requests for more/less boot images?
> 
..
> +		for img in zImage zImage.pseries zImage.iseries \
> +				dtbImage dtbImage.ps3

Yes.  How about all dtbImage, zImage, cuboot, treeboot, etc
that are newer than vmlinux?


milton
