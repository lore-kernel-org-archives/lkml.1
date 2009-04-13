Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZDMWsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZDMWsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 18:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZDMWs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 18:48:27 -0400
Received: from flatoutfitness.com ([66.178.130.209]:49491 "EHLO selene"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753146AbZDMWs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 18:48:26 -0400
X-Greylist: delayed 2169 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2009 18:48:26 EDT
Message-ID: <e3e0f4f0ca9fdce35c24b30559d10f31.squirrel@www.datavault.us>
Date: Mon, 13 Apr 2009 15:13:05 -0700 (PDT)
Subject: mcp55 forcedeth woes
From: "Yan Seiner" <yan@seiner.com>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a few Asus M2N-SLI deluxe mobos.  These mobos have the MCP55
chipset and two 1gb ethernet ports.  Occasionally, and for no reason that
I can figure out, these ports will die.  There are various ways to try and
fix these; they seem to be about 50% effective, and approach something
akin to voodoo.

Based on this discussion here:

http://patchwork.kernel.org/patch/16212/

I've gotten the ability to turn the ports on and off somewhat.

For port 0,

ethtool -s eth0 autoneg off speed 10 duplex full

turns on the link, and gets me half-duplex, 10mb/sec. Not much, granted.

ethtool -s eth0 autoneg off speed 100 duplex full

causes the link to go up and down on about a 2 second cycle.

ethtool -s eth0 autoneg on

causes the link to drop.

For port 1, the behavior is similar, except that I can get a stable 100
mbit connection.

So the problem is in the autoneg code. It's a driver issue as this is
reported widely to work under windows of various flavors.

I'm running 2.6.29.1; I'm ok with patching and building kernels, but I'm
not a kernel hacker.

What, if anything, can I provide and do to fix this?


-- 
Yan Seiner, PE

Support my bid for the 4J School Board
http://www.seiner.com

