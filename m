Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbXL2Mii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbXL2Mii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 07:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXL2Mia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 07:38:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55873 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbXL2Mia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 07:38:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47763FC2.8040701@s5r6.in-berlin.de>
Date: Sat, 29 Dec 2007 13:38:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Dave Young <hidave.darkstar@gmail.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 06/12] pci : Use mutex instead of semaphore in driver
 core
References: <20071229011057.GG2883@darkstar.te-china.tietoenator.com> <20071229025506.GL11638@parisc-linux.org> <477632A7.6050208@s5r6.in-berlin.de> <20071229121630.GP11638@parisc-linux.org>
In-Reply-To: <20071229121630.GP11638@parisc-linux.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sat, Dec 29, 2007 at 12:42:31PM +0100, Stefan Richter wrote:
>> I think a broken-up patch series isn't totally wrong to do for a first
>> look at these RFC patches.  Of course the series needs to become a
>> single patch before it is committed to a tree whose history needs to
>> support bijection, e.g. -mm.
> 
> For this kind of patch (converting a semaphore to a mutex), it is
> necessary to see everywhere that changes.  There's no way to tell if what
> he's doing is safe without seeing all the places that have to change,
> and verifying whether it breaks any of the rules in include/linux/mutex.h

Exactly.

> For other kinds of patches, you could well be right.

You can see the whole of the changes by looking at the whole of Dave's
postings.  (This would of course be simpler if it was a single posting.)
-- 
Stefan Richter
-=====-=-=== ==-- ===-=
http://arcgraph.de/sr/
