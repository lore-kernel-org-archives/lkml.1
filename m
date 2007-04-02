Return-Path: <linux-kernel-owner+w=401wt.eu-S1752032AbXDBCGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbXDBCGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 22:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXDBCGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 22:06:54 -0400
Received: from nessie.weebeastie.net ([220.233.7.36]:1483 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752032AbXDBCGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 22:06:54 -0400
X-Greylist: delayed 1514 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Apr 2007 22:06:53 EDT
Date: Mon, 2 Apr 2007 11:43:19 +1000
From: CaT <cat@zip.com.au>
To: linux-kernel@vger.kernel.org
Subject: intermittant petabyte usage reported with broadcom nic
Message-ID: <20070402014319.GA8345@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organisation: Furball Inc.
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I take minute by minute snapshots of network traffic by sampling
/proc/net/dev and most of the time everything works fine. Occasionally
though I get petabyte byte traffic and corresponding packet traffic.

This happens on an AMD64, dual core smp box with Broadcom NetXtreme II
nics. The issue happens with both nics but at different times. The same
sampling code runs on p4 boxes with ht on and e1000 nics without issues
so I don't believe it's an issue with my code (famous last words :)
which just does an re to extract the data on a per-line basis and prints
it out. Still, I'll be adding code to log any big readings and hopefully
it'll happen again sooner rather then later.

There is no preemption involved and the kernel is a monolythic build of
2.6.19.[12] (there are two servers).

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby
