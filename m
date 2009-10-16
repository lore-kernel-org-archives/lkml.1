Return-Path: <linux-kernel-owner+w=401wt.eu-S1763347AbZJPAx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763347AbZJPAx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 20:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbZJPAx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 20:53:56 -0400
Received: from the.earth.li ([217.147.81.2]:41886 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850AbZJPAxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 20:53:55 -0400
Date: Thu, 15 Oct 2009 17:53:19 -0700
From: Jonathan McDowell <noodles@earth.li>
To: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: X hangs with blank screen on 2.6.32-rc4 / Intel 915GM
Message-ID: <20091016005319.GC5658@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Trying 2.6.32-rc4 on my Toshiba R200 laptop running Debian Squeeze leads
to a blank screen with a flashing cursor in the top left when X starts.
If startup in such a way that X isn't automatically started the console
is fine, but starting X manually still leads to the hang. The machine
seems unresponsive at this point - I can't switch to a normal console
and the laptop fan comes on in a manner that suggests the CPU is
chugging away.

2.6.31.4 works fine.

X versions are as per up-to-date Squeeze - Xorg 7.4 with Intel 2.9.0.

I tried without VGA_ARB as that seemed to be the largest related change
that might affect X but not the console, but it didn't make a
difference.

dmesg from non X boot, Kernel config and lspci -vv output at:

http://the.earth.li/~noodles/i915-32-rc-x-broken/

I don't really have time at present to get involved in a full bisect,
but I can potentially try over the weekend if there's nothing more
obvious to try first.

J.

-- 
"The actual chances of it blowing are about one in...one." - Lister
