Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbXIGXV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbXIGXV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 19:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXIGXVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 19:21:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35227 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319AbXIGXVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 19:21:03 -0400
Date: Sat, 8 Sep 2007 00:20:59 +0100 (BST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Intel Memory Ordering White Paper
In-Reply-To: <200709081854.57549.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.0.999.0709080020040.9047@evo.linux-foundation.org>
References: <200709071526.51169.jesse.barnes@intel.com>
 <200709081854.57549.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Sep 2007, Nick Piggin wrote:
> 
> So, can we finally noop smp_rmb and smp_wmb on x86?

Did AMD already release their version? If so, we should probably add a 
commit that does that in somewhat early 2.6.24 rc, and add the pointers to 
the whitepapers in the commit message.

		Linus
