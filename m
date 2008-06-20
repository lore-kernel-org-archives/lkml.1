Return-Path: <linux-kernel-owner+w=401wt.eu-S934015AbYFTUuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015AbYFTUuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758045AbYFTUuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:50:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51219
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756212AbYFTUuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:50:07 -0400
Date: Fri, 20 Jun 2008 13:50:06 -0700 (PDT)
Message-Id: <20080620.135006.243389159.davem@davemloft.net>
To: stern@rowland.harvard.edu
Cc: linux-kernel@vger.kernel.org, antonio.lin@alcormicro.com,
       david.vrabel@csr.com
Subject: Re: Scatter-gather list constraints
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.44L0.0806201623080.2133-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0806201623080.2133-100000@iolanthe.rowland.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>
Date: Fri, 20 Jun 2008 16:30:25 -0400 (EDT)

> This question arises in connection with wireless USB mass-storage
> devices.  The controller driver requires that all DMA segments
> in a transfer, other than the last one, have a multiple of 1024 bytes.  
> But we're sometimes getting s-g lists where an element contains an odd
> number of 512-byte sectors, and of course it doesn't work.

The generic device layer DMA bits does have ways to indicate
DMA restrictions such as maximum segment size, but not something
like this.

This is a pretty strange requirement, and would be probably be
quite difficult to support across the board just to handle this
strange device :)
