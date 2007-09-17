Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbXIQUol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbXIQUol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbXIQUoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:44:34 -0400
Received: from nef2.ens.fr ([129.199.96.40]:3328 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbXIQUod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:44:33 -0400
Date: Mon, 17 Sep 2007 22:43:25 +0200
From: David Madore <david.madore@ens.fr>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: patch/option to wipe memory at boot?
Message-ID: <20070917204325.GA23658@clipper.ens.fr>
References: <20070917155149.GA5453@clipper.ens.fr> <46EEC368.1040308@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EEC368.1040308@goop.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Mon, 17 Sep 2007 22:43:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:11:52AM -0700, Jeremy Fitzhardinge wrote:
> Boot memtest86 for a little while before booting the kernel?  And if you
> haven't already run it for a while, then that would be your first step
> anyway.

Indeed, that does the trick, thanks for the suggestion.  So I can be
quite confident, now, that my RAM is sane and it's just that the BIOS
doesn't initialize it properly.

But I'd still like some way of filling the RAM when Linux starts (or
perhaps in the bootloader), because letting memtest86 run after every
cold reboot isn't a very satisfactory solution.

Happy hacking,

-- 
     David A. Madore
    (david.madore@ens.fr,
     http://www.madore.org/~david/ )
