Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbZEVUgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbZEVUgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756952AbZEVUgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:36:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50940 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbZEVUgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:36:37 -0400
Date: Fri, 22 May 2009 22:42:46 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Message-ID: <20090522204246.GH846@one.firstfloor.org>
References: <200905221139.26941.lkml@morethan.org> <200905221453.41895.lkml@morethan.org> <20090522200536.GZ10166@const.famille.thibault.fr> <200905221532.43775.lkml@morethan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905221532.43775.lkml@morethan.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If it: "Does not make a difference" then it "Should not make a difference"
> but it does, try it yourself.  Its safe (if LOCK_PREFIX is in the proper
> places) - the machine will ignore the opcode if is recent enough to not
> need it - just trust the cpu's micro-code.

It doesn't ignore it, in fact it's extremly slow on some older systems
where all atomic operations are very costly.
That is why LOCK is avoided as much as possible.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
