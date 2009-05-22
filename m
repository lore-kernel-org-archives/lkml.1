Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbZEVUpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbZEVUpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZEVUpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:45:06 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:59576 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbZEVUpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:45:04 -0400
X-IronPort-AV: E=Sophos;i="4.41,235,1241395200"; 
   d="scan'208";a="168557223"
From: Roland Dreier <rdreier@cisco.com>
To: lkml@MoreThan.org
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221139.26941.lkml@morethan.org>
	<200905221453.41895.lkml@morethan.org>
	<20090522200536.GZ10166@const.famille.thibault.fr>
	<200905221532.43775.lkml@morethan.org>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 22 May 2009 13:45:03 -0700
In-Reply-To: <200905221532.43775.lkml@morethan.org> (Michael S. Zick's message
	of "Fri, 22 May 2009 15:32:41 -0500")
Message-ID: <adafxewamuo.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 22 May 2009 20:45:03.0944 (UTC) FILETIME=[2EEB3C80:01C9DB1E]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > > Ref: http://developer.intel.com/Assets/PDF/manual/253666.pdf
 > > > Manual page: 3-590  PDF page: 638
 > > > Summary: Processors prior to P-4 can take an interrupt between
 > > > the read cycle and the write cycle. Which is why opcode 0xF0 exists.

 > > Where do you see page 638/639 talking about interrupts?  It talks about
 > > multi-processor machines.

 > No - it talks about "exclusive memory access" - You got bus master DMA
 > in your test machine? You also have an older than P-4 single processor?

I looked at the page you refer to.  I talks about asserting the LOCK#
signal -- there is absolutely no mention of the lock prefix having any
effect on the execution of an instruction internal to a single CPU.
Could you be more specific about what you are referring to?

 > Look people, I just reported what I found from testing - 
 > Please don't shoot the messanger.

Could you be specific about the test you are doing?  What operation are
you doing that is missing the lock prefix?  What is the expected result,
and what actually happens without the lock prefix?

 - R.
