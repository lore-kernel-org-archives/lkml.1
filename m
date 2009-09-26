Return-Path: <linux-kernel-owner+w=401wt.eu-S1752551AbZIZSUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbZIZSUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZIZSUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:20:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48169 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZIZSUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:20:40 -0400
Date: Sat, 26 Sep 2009 20:20:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [origin tree build failure] Re: [PULL] Please pull hwpoison code for 2.6.32
Message-ID: <20090926182043.GU30185@one.firstfloor.org>
References: <20090926172802.GS30185@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926172802.GS30185@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 11:15:23AM -0700, H. Peter Anvin wrote:
> We're definitely going to continue to have this problem until we decide we have hit the pain threshold either support external *zone* numbers or permit a 64-bit pageflags.

Yes I agree. I implemented a perfect hash scheme for the NUMA pfn->node
mapping a long time ago which is still there, that code could be probably
extended to support zones too. It would just make the hash slightly larger.

-Andi
