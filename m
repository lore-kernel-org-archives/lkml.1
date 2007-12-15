Return-Path: <linux-kernel-owner+w=401wt.eu-S1759042AbXLOBcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042AbXLOBcl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 20:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXLOBcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 20:32:32 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:35652 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbXLOBcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 20:32:31 -0500
Date: Sat, 15 Dec 2007 02:32:30 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Gosney, JeremiX" <jeremix.gosney@intel.com>
cc: linux-kernel@vger.kernel.org, "Peters, Gordon" <gordon.peters@intel.com>,
       "Sy, Dely L" <dely.l.sy@intel.com>
Subject: Re: ARP Bug?
In-Reply-To: <F2B6B9EAC551DA4AA8833629D55D9CA8482D4C@orsmsx418.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0712150231090.22877@fbirervta.pbzchgretzou.qr>
References: <F2B6B9EAC551DA4AA8833629D55D9CA8482D4C@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 14 2007 17:11, Gosney, JeremiX wrote:
>Subject: ARP Bug?
>
>We've noticed the 2.6-based Linux systems in our test lab are
>experiencing some "ARP flux"-like symptoms.  
>
>The systems reply with eth0's hardware address to all ARP requests,

If you have the same subnet on multiple interfaces, only the
first interface will be served.

Case closed?

>regardless of the IP being queried.  Because of this, the system will
>only send and receive packets on eth0; if eth0 is brought down, the
>system is unreachable even though it still has several active
>connections.  With eth0 unplugged, none of the other interfaces are
>reachable (this is presumably a side-effect caused by the switch ARP
>cache.) Failover routes are defined in the routing table, but the system
>still will not send/receive packets out those interfaces.
>

I am not sure ARP even uses the routing table.
