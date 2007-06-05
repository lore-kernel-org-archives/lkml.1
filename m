Return-Path: <linux-kernel-owner+w=401wt.eu-S1764280AbXFESvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764280AbXFESvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 14:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758452AbXFESvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 14:51:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740AbXFESvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 14:51:13 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] lguest-fix-divide-error-implement-sched_clock
Date: Tue, 5 Jun 2007 20:51:02 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
References: <20070522223828.GV11115@waste.org> <200706051837.22847.ak@suse.de> <4665AEE5.7040904@zytor.com>
In-Reply-To: <4665AEE5.7040904@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706052051.02823.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> That's a vendor check foul.  That should be a CPU feature flag.
>
> Looks like there is some work to be done here.

No.

That would just move that code elsewhere, but there is still only
a single caller who actually uses this. Besides there are further
checks to be done here (see x86-64) which does some things here
(like IO-APIC accesses) that you definitely don't want in the cpu init code.

-Andi
