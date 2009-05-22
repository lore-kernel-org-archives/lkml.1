Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZEVU6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZEVU6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZEVU5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:57:55 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:37490 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340AbZEVU5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:57:55 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
Date: Fri, 22 May 2009 15:57:51 -0500
User-Agent: KMail/1.9.9
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org
References: <200905221139.26941.lkml@morethan.org> <200905221532.43775.lkml@morethan.org> <20090522204246.GH846@one.firstfloor.org>
In-Reply-To: <20090522204246.GH846@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221557.54195.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri May 22 2009, Andi Kleen wrote:
> > If it: "Does not make a difference" then it "Should not make a difference"
> > but it does, try it yourself.  Its safe (if LOCK_PREFIX is in the proper
> > places) - the machine will ignore the opcode if is recent enough to not
> > need it - just trust the cpu's micro-code.
> 
> It doesn't ignore it, in fact it's extremly slow on some older systems
> where all atomic operations are very costly.
> That is why LOCK is avoided as much as possible.
> 

I'm only the messanger.

Mike
> -Andi


