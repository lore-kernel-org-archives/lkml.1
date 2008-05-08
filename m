Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbYEHBMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbYEHBMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 21:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754618AbYEHBMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 21:12:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752889AbYEHBMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 21:12:05 -0400
Date: Wed, 7 May 2008 18:11:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: Jens Rottmann <JRottmann@LiPPERT-AT.de>, jordan.crouse@amd.com,
       linux-kernel@vger.kernel.org, linux-geode@bombadil.infradead.org,
       linux-fbdev-devel@lists.sourceforge.net, torvalds@linux-foundation.org
Subject: Re: lxfb driver regression
Message-Id: <20080507181140.ecea2305.akpm@linux-foundation.org>
In-Reply-To: <20080507210836.1eb61b8f@ephemeral>
References: <20080507210836.1eb61b8f@ephemeral>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008 21:08:36 -0400 Andres Salomon <dilinger@queued.net> wrote:

> Hi,
> 
> I noticed that a patch from you went into 2.6.26-rc1 to adjust the PLL table
> in the lxfb driver.  Unfortunately, it breaks on OLPC machines (I haven't
> tested it on other Geode platforms yet, but I don't have any other Geodes
> with panels anyways).  It's this commit:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3888d4639e78802c4ec1086127124e890461b9e4
> 
> Without this patch, I get the following (correct) output from the lxfb
> and console code:
> 
> [    0.939827] lxfb 0000:00:01.1: 16384 KB of video memory at 0xfd000000
> [    1.009194] Console: switching to colour frame buffer device 150x56     
> 
> Without it, the cols/width is screwy (and I get a blank white screen):
> 
> [   20.706836] lxfb 0000:00:01.1: 16384 KB of video memory at 0xfd000000
> [   20.788538] Console: switching to colour frame buffer device 100x40        

I queued a reversion but (as is often the case with non-critical
regressions) I'll hold off for a few days, see if we can get things fixed
up.

