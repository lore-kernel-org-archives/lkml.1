Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbYBNCZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbYBNCZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 21:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbYBNCZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 21:25:24 -0500
Received: from main.gmane.org ([80.91.229.2]:40755 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbYBNCZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 21:25:23 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Driver removals
Date: Wed, 13 Feb 2008 21:26:26 -0500
Message-ID: <fp08q7$jv0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-68-236-140-141.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a general thought on removing drivers in general, when a driver is 
removed because there's a better one, it would be good to have either a 
message which shows up at "make oldconfig" time, or a file listing the 
driver(s) which replace it.

Half the resistance to removing drivers is finding what is supposed to 
replace the driver. For instance a list of all the drivers Adrian Bunk 
has suggested to replace sk98lin, so users have something better than 
searching the source code and/or LKML archive to find the next thing to try.

In general, if a driver works and is being used, until it *needs* 
attention I see no reason to replace it. I don't agree that "it forces 
people to try the new driver" is a valid reason, being unmaintained is 
only a problem if it needs maintenance. I am not going to reopen that 
topic, I'm simply noting a general opposition to unfunded mandates, and 
requiring changes to kernel, module and/or rc.local config is just that.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

