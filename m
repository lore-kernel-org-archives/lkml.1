Return-Path: <linux-kernel-owner+w=401wt.eu-S932391AbYBOITZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbYBOITZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 03:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbYBOITS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 03:19:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46984 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbYBOITR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 03:19:17 -0500
Date: Fri, 15 Feb 2008 09:55:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       torvalds@osdl.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix left over EFI cache mapping problems
Message-ID: <20080215085501.GC25949@one.firstfloor.org>
References: <20080214131317.GA27769@basil.nowhere.org> <20080214161218.GA28152@elte.hu> <20080214171603.GC16255@one.firstfloor.org> <20080214183819.GA19846@elte.hu> <1203043953.30010.14.camel@caritas-dev.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203043953.30010.14.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But because end_pfn_map contains the above UC memory area, efi_ioremap()
> is not used on EFI 64.

I see. It would be a good idea if you could test with a limited
memmap (mem=... command line option) just to make sure this path works

Right now I don't think pageattr.c will deal fully correct with 
the fixmap, but if the git-x86#mm changes are pushed for .25
it might actually work.

-Andi
