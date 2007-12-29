Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbXL2MQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbXL2MQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 07:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbXL2MQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 07:16:32 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:56352 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbXL2MQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 07:16:31 -0500
Date: Sat, 29 Dec 2007 05:16:30 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Dave Young <hidave.darkstar@gmail.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 06/12] pci : Use mutex instead of semaphore in driver core
Message-ID: <20071229121630.GP11638@parisc-linux.org>
References: <20071229011057.GG2883@darkstar.te-china.tietoenator.com> <20071229025506.GL11638@parisc-linux.org> <477632A7.6050208@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477632A7.6050208@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 12:42:31PM +0100, Stefan Richter wrote:
> I think a broken-up patch series isn't totally wrong to do for a first
> look at these RFC patches.  Of course the series needs to become a
> single patch before it is committed to a tree whose history needs to
> support bijection, e.g. -mm.

For this kind of patch (converting a semaphore to a mutex), it is
necessary to see everywhere that changes.  There's no way to tell if what
he's doing is safe without seeing all the places that have to change,
and verifying whether it breaks any of the rules in include/linux/mutex.h

For other kinds of patches, you could well be right.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
