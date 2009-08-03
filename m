Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZHCCQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZHCCQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 22:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbZHCCQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 22:16:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753099AbZHCCQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 22:16:09 -0400
Date: Sun, 2 Aug 2009 19:14:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
In-Reply-To: <4A76421E.3040005@kernel.org>
Message-ID: <alpine.LFD.2.01.0908021913130.3352@localhost.localdomain>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org> <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain> <20090731195705.GA12270@elte.hu> <alpine.LFD.2.01.0908011214330.3304@localhost.localdomain> <4A76421E.3040005@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Aug 2009, Tejun Heo wrote:
> 
> Do you want to queue it for 2.6.31?

Yeah, no.

>			 Given that the generated code
> changes compared to the previous kernels (both pre and post percpu
> stuff), I think it would be safer to queue it for 2.6.32 window.  I
> would be happy to carry it in the percpu tree.

Please do. I don't want it for 31, and I do want it to get more testing. I 
ran with it for a few days, and saw no problems, and it looked obvious 
enough, but there just isn't any overriding reason for it to be in 31.

		Linus
