Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXHGMps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXHGMps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759698AbXHGMpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:45:39 -0400
Received: from bram.avontuur.org ([84.244.182.76]:51234 "EHLO
	bram.avontuur.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759460AbXHGMph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:45:37 -0400
Date: Tue, 7 Aug 2007 14:45:35 +0200
From: Bram <bram@linux.kernel.as.avontuur.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Possible bug in realtek 8169 ethernet driver
Message-ID: <20070807124535.GO2761@avontuur.org>
References: <20070805155915.GM2761@avontuur.org> <20070805213557.GA21500@electric-eye.fr.zoreil.com> <20070806133752.GN2761@avontuur.org> <20070806210637.GA18611@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070806210637.GA18611@electric-eye.fr.zoreil.com>
X-Verification-Tag: brama@localhost
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:
> Bram <bram@linux.kernel.as.avontuur.org> :
> [...]
> > The device now works! But, it still comes up as eth2 instead of eth0,
> > even though it's first detected as eth0. There are no other network
> 
> Check the udev rules and/or your init scripts ?
> 
You're right, it's a udev script assigning new names to unknown cards, I
wasn't aware of that.

Thanks,
Bram
