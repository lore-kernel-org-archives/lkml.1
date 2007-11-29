Return-Path: <linux-kernel-owner+w=401wt.eu-S1763973AbXK2Xp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763973AbXK2Xp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763005AbXK2XpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:45:17 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:51036 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762939AbXK2XpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:45:16 -0500
Date: Fri, 30 Nov 2007 00:45:05 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Christoph Hellwig <hch@infradead.org>
cc: linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
In-Reply-To: <20071125163014.GA17922@infradead.org>
Message-ID: <alpine.DEB.0.99999.0711300037520.9287@sheep.housecafe.de>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org>
User-Agent: Alpine 0.99999 (DEB 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Nov 2007, Christoph Hellwig wrote:
> This patch does exactly that and reverts xfs_file_readdir to what's
> basically the 2.6.23 version minus the uio and vnops junk.

Thanks, works here too (without nordirplus as a mountoption).
Am I supposed to close the bug[0] or do you guys want to leave this
open to track the Real Fix (TM) for 2.6.25?

Again, thank you for the fix!
Christian.

[0] http://bugzilla.kernel.org/show_bug.cgi?id=9400
-- 
BOFH excuse #112:

The monitor is plugged into the serial port
