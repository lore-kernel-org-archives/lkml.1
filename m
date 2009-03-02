Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbZCAXzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbZCAXzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 18:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZCAXzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 18:55:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46071 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbZCAXzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 18:55:38 -0500
Date: Mon, 2 Mar 2009 01:14:12 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jody Belka <lists-xen@pimb.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] xen: core dom0 support
Message-ID: <20090302001412.GL26292@one.firstfloor.org>
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <20090227212812.26d02f34.akpm@linux-foundation.org> <49A8DF28.4050301@goop.org> <200902282309.07576.nickpiggin@yahoo.com.au> <20090228181115.GU2056@pimb.org> <871vti2zsl.fsf@basil.nowhere.org> <49AB1C7D.2040605@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AB1C7D.2040605@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But that suggests the *only* reason to update kernels is to get new 

Wait, it was about Dom0. They could still get all the features 
of the new kernels in a guest DomU.

> While a lot of the delta between 2.6.18 has been hardware support 
> updates, there have been a lot of other useful things: a new CPU 
> scheduler, tickless operation (which directly important for 

The old Dom0s always did no idle tick. And I suspect most
of the other things don't matter very much in a minimal Dom0.

That said I'm not arguing that it shouldn't be merged, but it 
seems like the "old hardware" argument is not very strong.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
