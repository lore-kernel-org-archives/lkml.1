Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYAXU2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYAXU2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYAXU2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:28:00 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:34959 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbYAXU17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:27:59 -0500
Date: Thu, 24 Jan 2008 14:24:20 -0600
From: Scott Wood <scottwood@freescale.com>
To: Timur Tabi <timur@freescale.com>
Cc: avorontsov@ru.mvista.com, Poonam_Aggrwal-b10812 <b10812@freescale.com>,
       michael.barkowski@freescale.com, netdev@vger.kernel.org,
       kumar.gala@freescale.com, linux-kernel@vger.kernel.org,
       rubini@vision.unipv.it, linuxppc-dev@ozlabs.org,
       ashish.kalra@freescale.com, rich.cutler@freescale.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH UCC TDM 1/3 Updated] Platform changes for UCC TDM
	driver for MPC8323eRDB. Also includes related QE changes and dts
	entries.
Message-ID: <20080124202420.GC3926@loki.buserror.net>
References: <Pine.LNX.4.64.0801241553270.4984@linux121> <20080124154804.GA22178@localhost.localdomain> <4798B4F3.2010101@freescale.com> <20080124162345.GA27359@localhost.localdomain> <4798BDEB.2010501@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4798BDEB.2010501@freescale.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 10:33:47AM -0600, Timur Tabi wrote: Yes, but
> deciding what the UCC does might not be static.  At what point do we
> declare, "UCC5 is for eth0 and eth0 only"?

When the board designer decides to hook eth0 up to UCC5.

If the board designer decides to hook multiple devices up to UCC5, we first
smack the board designer, and then set it up to whichever configuration has
been jumpered.

-Scott
