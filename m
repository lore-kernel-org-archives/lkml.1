Return-Path: <linux-kernel-owner+w=401wt.eu-S933203AbXCZWAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbXCZWAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 18:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933238AbXCZV77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:59:59 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54414 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933231AbXCZV76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:59:58 -0400
Date: Mon, 26 Mar 2007 14:59:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch 2.6.21-rc5 1/3] parport->dev driver model support
Message-Id: <20070326145942.a090d277.akpm@linux-foundation.org>
In-Reply-To: <200703260906.19442.david-b@pacbell.net>
References: <200703260906.19442.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 09:06:19 -0700
David Brownell <david-b@pacbell.net> wrote:

> Currently a parport_driver can't get a handle on the device node for the
> underlying parport (PNPACPI, PCI, etc).  That prevents correct placement
> of sysfs child nodes, which can affect things like power management.
> 
> This patch adds a field to "struct parport" pointing to that device node,
> and updates non-legacy port drivers to initialize that device pointer.
> That field replaces the analagous PCI-only support in parport_pc.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> NOTE this depends on an earlier patch to make pnp devices set up DMA,
> parport is the primary user of legacy i8237 dma infrastructure.

Confusion reigns.

To which "earlier patch" do you refer?
