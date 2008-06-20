Return-Path: <linux-kernel-owner+w=401wt.eu-S933151AbYFTUpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbYFTUpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764281AbYFTUa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:30:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40595 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1764272AbYFTUa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:30:26 -0400
Date: Fri, 20 Jun 2008 16:30:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
cc: AntonioLin <antonio.lin@alcormicro.com>,
       David Vrabel <david.vrabel@csr.com>
Subject: Scatter-gather list constraints
Message-ID: <Pine.LNX.4.44L0.0806201623080.2133-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any way to express the constraint that for a particular 
request queue, all members of a scatter-gather list (except the last) 
must be a multiple of a particular length?

This question arises in connection with wireless USB mass-storage
devices.  The controller driver requires that all DMA segments
in a transfer, other than the last one, have a multiple of 1024 bytes.  
But we're sometimes getting s-g lists where an element contains an odd
number of 512-byte sectors, and of course it doesn't work.

Thanks,

Alan Stern

