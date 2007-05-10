Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbXEJJV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbXEJJV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759918AbXEJJVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:21:18 -0400
Received: from 1wt.eu ([62.212.114.60]:2547 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759767AbXEJJVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:21:16 -0400
Date: Thu, 10 May 2007 11:21:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: Zbigniew Baniewski <zb@ispid.com.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "modularized" 2.4.34.4  ->  ide-core "unresolved symbols"
Message-ID: <20070510092111.GA10506@1wt.eu>
References: <20070505194922.GA13176@localhost.localdomain> <20070506043645.GF943@1wt.eu> <20070508202334.GA16185@localhost.localdomain> <20070508211646.GA3129@1wt.eu> <20070508221425.GA18244@localhost.localdomain> <20070508223922.GB31591@1wt.eu> <20070509220544.GA14957@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509220544.GA14957@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 12:05:44AM +0200, Zbigniew Baniewski wrote:
> So, I changed the config (below) and made another compilation - still the
> same:
> ------------------------
> ...ordinary boot messages, ending with "hda:... sectors... w/Cache..."
> hda: attached ide-disk driver
> hda:<1>Unable to handle kernel paging request at virtual address ffffff00 
> printing eip:
> 
> ...a lot of interesting stuff...              
> 
> <0>Kernel panic: Attempted to kill the idle task!
> In idle task - not syncing.
> -----------------------
> 
> I'm afraid, kernel 2.4.34.4 is just broken.

As I previously asked, could you tell me what is the last version that is
known to work with this config ?

Also, is it possible for you to capture the oops and decode it, or even
easier, please send me your kernel and initrd so that I can quickly boot
it on another machine and see how it behaves.

If it is a config problem, we must understand it and see what we can do to
avoid people get trapped by it again, and if it's a bug, we must fix it.

Regards,
Willy

