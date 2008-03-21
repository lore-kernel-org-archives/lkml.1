Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbYCURw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbYCURw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYCURwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:52:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46591 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbYCURwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:52:49 -0400
Date: Fri, 21 Mar 2008 18:55:38 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, andreas.herrmann3@amd.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/7] CPA: Add statistics about state of direct mapping v2
Message-ID: <20080321175538.GI2346@one.firstfloor.org>
References: <20080312353.598285931@firstfloor.org> <20080312025333.BAF5F1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211822220.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803211822220.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 06:41:59PM +0100, Thomas Gleixner wrote:
> On Wed, 12 Mar 2008, Andi Kleen wrote:
> > Add information about the mapping state of the direct mapping to 
> > /proc/meminfo.
> 
> Please use debugfs for this.

But it's not debugging. Or are you saying all memory state information
in /proc/meminfo is debugging information?  I would say it is generic
memory state tracking, similar to VmallocUsed or Slab: or NFS_Unstable:
e.g. I would expect a machine to go slower if all direct mapping pages
are split due to increase TLB misses and that information is generally
useful and should not be forced into some debugging ghetto.

-Andi

