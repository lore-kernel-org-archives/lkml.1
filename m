Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbXEQVPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbXEQVPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbXEQVPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:15:07 -0400
Received: from main.gmane.org ([80.91.229.2]:47925 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbXEQVPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:15:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Philip Pemberton <usenet07@philpem.me.uk>
Subject: IPv6: 6to4 tunnel randomly cutting out on 2.6.8.1 - any patches?
Date: Thu, 17 May 2007 21:59:31 +0100
Message-ID: <f2ifnf$ooh$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 87-194-114-122.bethere.co.uk
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   I'm currently trying to set IPv6 up on a Linux-based router. The 
aforementioned router runs kernel 2.6.8.1, and just about all the hardware 
driver modules are binary modules. For the record, I'd love to upgrade the 
router to one of the newer kernels, but AIUI I can't do it because I don't 
have the source to the bmods. But anyway...

   What I've done is set up an IPv6 subnet via the SixXS tunnel broker (and 
I've also tried the BT Exact tunnel broker, which has the same problem). This 
tunnel is then routed onto my LAN and set up router advertisement (with radvd) 
so the machines can get access to the IPv6 side of the Internet.

   The problem is that every 10 minutes or so, the IPv6 link (apparently the 
routing side as the router can still ping kame.net, but the other machines on 
the LAN can't) stops working for a few seconds (between 5 and 60) and comes 
back up of its own free will. Running the tunnel on another machine (with a 
2.6.16 kernel) stops the problem completely - IPv6 works perfectly. But being 
the energy-conscious person I am, I'd prefer to have as few machines powered 
up as possible.

   When IPv6 stops working, ping returns the error "sendmsg: Network is 
unreachable". The intermittent nature of this issue, and the fact that IPv6 
works fine when I move routing to a machine with a later kernel, leads me to 
believe that this may be an old kernel bug that got fixed in a later release, 
but evidently not this one...

   There appear to be a number of IPv6 related fixes in 2.6.9, but the patches 
are all globbed together in a single "patch-2.6.9.bz2" file - I'd like to 
apply some of the more promising ones directly, and try and fix the problem 
that way. The problem being that I can't find these patches as individual 
"this fixes X" releases, just as one huge 'go from 2.6.8.1 to 2.6.9' glob, and 
the git repository on kernel.org only seems to go back to 2.6.11.

   So what I'm wondering is, does anyone know if a bug like I've described was 
ever found between 2.6.8.1 and 2.6.16, and if so how it can be fixed?

Thanks.
-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
usenet07@philpem.me.uk        | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.
If mail bounces, replace "07" with the last two digits of the current year.

