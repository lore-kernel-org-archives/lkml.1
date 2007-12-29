Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXL2Lmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXL2Lmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 06:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbXL2Lmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 06:42:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54076 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbXL2Lmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 06:42:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <477632A7.6050208@s5r6.in-berlin.de>
Date: Sat, 29 Dec 2007 12:42:31 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Dave Young <hidave.darkstar@gmail.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 06/12] pci : Use mutex instead of semaphore in driver
 core
References: <20071229011057.GG2883@darkstar.te-china.tietoenator.com> <20071229025506.GL11638@parisc-linux.org>
In-Reply-To: <20071229025506.GL11638@parisc-linux.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> Patches should be self-contained for ease of bisecting.  I can't tell
> whether this patch is correct or not because you haven't included all
> the other places that need to change at the same time as this.

I think a broken-up patch series isn't totally wrong to do for a first
look at these RFC patches.  Of course the series needs to become a
single patch before it is committed to a tree whose history needs to
support bijection, e.g. -mm.

However, Dave's postings lack a References: header which refer to his
00/12 posting.

(Also, a bonus in the 00/12 posting would be a listing of all patch
titles in the series and the total diffstat of the series, but nearly
nobody does this.)
-- 
Stefan Richter
-=====-=-=== ==-- ===-=
http://arcgraph.de/sr/
