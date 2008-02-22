Return-Path: <linux-kernel-owner+w=401wt.eu-S1760161AbYBVQvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760161AbYBVQvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbYBVQuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:50:52 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:50238 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbYBVQuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:50:51 -0500
Date: Fri, 22 Feb 2008 10:50:01 -0600
From: Scott Wood <scottwood@freescale.com>
To: mahendra varman <mahendravarman15@gmail.com>
Cc: linuxppc-embedded@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Doubt in Device tree entry for USB on Powerpc based board
Message-ID: <20080222165001.GA19953@ld0162-tx32.am.freescale.net>
References: <4ac2955e0802220533o3eba0e58ybb72326ab0e1a376@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ac2955e0802220533o3eba0e58ybb72326ab0e1a376@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 07:03:07PM +0530, mahendra varman wrote:
> Please help me in the device tree where to give the device type
> compatibility address_cells size cells for the USB (since usb controller is
> in pci bridge i have some confusion in where to give the entry for usb)

You don't need to describe PCI devices in the device tree; they are
probed at runtime.

-Scott
