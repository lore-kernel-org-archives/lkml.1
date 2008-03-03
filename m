Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbYCCSpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbYCCSpR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYCCSpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:45:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752356AbYCCSpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:45:03 -0500
Date: Mon, 3 Mar 2008 10:44:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Ingo Molnar <mingo@elte.hu>, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
In-Reply-To: <47CC451A.2060501@linux.intel.com>
Message-ID: <alpine.LFD.1.00.0803031042230.17889@woody.linux-foundation.org>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Mar 2008, Arjan van de Ven wrote:
> 
> interesting observation: if I turn the macros into inlines... the difference
> goes away.
> 
> I'm half tempted to just do it as inline period ... any objections ?

Yes, I object. I want to understand why it would matter. If this is a 
compiler bug, it's a really rather bad one. And if it's just some stupid 
bug in our pmd_bad() macro, I still want to know what the problem was.

Can you compile both ways and look at what changed at the offending site 
(which is apparently "follow_page()")?

And do you have some odd compiler version?

		Linus
