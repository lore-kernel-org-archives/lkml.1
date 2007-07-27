Return-Path: <linux-kernel-owner+w=401wt.eu-S1764061AbXG0EsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764061AbXG0EsZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 00:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbXG0EsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 00:48:17 -0400
Received: from pcls5.std.com ([192.74.137.145]:54235 "EHLO TheWorld.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751659AbXG0EsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 00:48:16 -0400
From: Alan Curry <pacman@TheWorld.com>
Message-Id: <200707270448.l6R4m1O31531714@shell01.TheWorld.com>
Subject: Re: [PATCH] powerpc: Pegasos keyboard detection
To: akpm@linux-foundation.org (Andrew Morton)
Date: Fri, 27 Jul 2007 00:48:01 -0400 (EDT)
Cc: benh@kernel.crashing.org (Benjamin Herrenschmidt),
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20070726212241.032e9755.akpm@linux-foundation.org> from "Andrew Morton" at Jul 26, 2007 09:22:41 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes the following:
>> > 
>> > Did this get merged, or otherwise fixed?  Even though the code in there has
>> > changed quite a bit, it looks to my untrained eye like the fix is still
>> > applicable?
>> 
>> Merged a fixed version:
>> 
>> f5d834fc34e61f1a40435981062000e5d2b2baa8
>> 
>> (In linus tree as of now)
>
>I hope so.  Alan's patch looks rather different from what you have now:
>fall back to of_find_node_by_name() if of_find_node_by_type() failed.
>

Looking at it via gitweb, I think the commit mentioned above is actually the
same as what I submitted. The diff context lines are different because there
was a similar patch in between the 2.6.22 release and my patch, which
apparently fixed the same problem on a different type of machine. It looks
like these 2 workarounds will function independently of each other.

The first 8042-detection fix was:
db0dbae9d9680bce69fe1ce775709e60c8ee9c29

And mine is:
f5d834fc34e61f1a40435981062000e5d2b2baa8

-- 
Alan Curry
pacman@world.std.com
