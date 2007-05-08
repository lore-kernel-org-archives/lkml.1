Return-Path: <linux-kernel-owner+w=401wt.eu-S968135AbXEHPcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968135AbXEHPcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbXEHPYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:24:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966388AbXEHPRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:17:34 -0400
Date: Tue, 8 May 2007 08:17:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Prarit Bhargava <prarit@redhat.com>,
       Andi Kleen <andi@basil.nowhere.org>
Subject: Re: Please revert 86c0baf123e474b6eb404798926ecf62b426bf3a
In-Reply-To: <20070508134928.GA13212@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0705080815480.3974@woody.linux-foundation.org>
References: <20070508134928.GA13212@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 May 2007, Russell King wrote:
> 
> Shall I invent __CPUINIT to mark data to always be thrown away, or are
> the x86 folk going to withdraw this patch and do it properly?

I can certainly revert the patch, but it would probably be better if you 
were to just start adding the infrastructure you need and send it as a new 
patch instead (where the revert is part of it, and the __CPUINIT is 
additional). 

		Linus
