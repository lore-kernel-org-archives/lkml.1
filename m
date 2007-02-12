Return-Path: <linux-kernel-owner+w=401wt.eu-S964812AbXBLKZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbXBLKZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 05:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964823AbXBLKZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 05:25:24 -0500
Received: from ikar.perftech.si ([195.246.0.20]:14270 "EHLO ikar.perftech.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964812AbXBLKZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 05:25:23 -0500
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 05:25:23 EST
X-ASG-Debug-ID: 1171275255-796100390000-xx1T2L
X-Barracuda-URL: http://10.12.0.14:5000/cgi-bin/mark.cgi
X-Barracuda-Connect: unknown[10.12.0.44]
X-Barracuda-Start-Time: 1171275255
Date: Mon, 12 Feb 2007 11:14:11 +0100
From: "xerces8" <xerces8@butn.net>
To: linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: Fw: Different routing for one process ?
Subject: Fw: Different routing for one process ?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <WorldClient-F200702121114.AA14110070@butn.net>
X-Mailer: WorldClient 9.5.4
X-Authenticated-Sender: xerces8@butn.net
X-Spam-Processed: POP, Mon, 12 Feb 2007 11:14:14 +0100
	(not processed: message from valid local sender)
X-Return-Path: xerces8@butn.net
X-Envelope-From: xerces8@butn.net
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
X-MDAV-Processed: POP, Mon, 12 Feb 2007 11:14:15 +0100
X-Barracuda-Virus-Scanned: by OUTBOUND - ikar.perftech.si at perftech.si
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=UNPARSEABLE_RELAY
X-Barracuda-Spam-Report: Code version 3.1, rules version 3.1.8465
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 UNPARSEABLE_RELAY      Informational: message has unparseable relay
	                           lines
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me on replies (not subscribed)
I sent this to linux-net, but they are on vacation ;-)


Hi!
 
Is there a way to make one process route differently than the rest of the system ?
 
My situation is this: I have a PC on a very restrictive network ((P)NAT&filtering). I want to
run an application that is more or less a SIP telephone client. SIP is of course blocked on
the network. The only option I see is a tunnel to a friendlier place on the net and route
the SIP traffic over it. This I already did using OpenVPN. The problem is, that I want to
the tunnel to be used for the SIP application only and not other net access (due to limited
bandwidth of the tunnel and other reasons).
 
My current solution is to run the SIP application inside a VMWare virtual machine, that does
all it's networking over the tunnel.
 
I wonder if I can do it without running vmware, since that seems like shooting a sparrow with a cannon.
 
Note that the SIP client can communicate with the entire world, I can not predict who will call me
and from what IP address.
 
(I linger between linux and windows, so if someone knows a person or mail list with windows
network experts, that would be helpful too)
 
 
Regards,
David


