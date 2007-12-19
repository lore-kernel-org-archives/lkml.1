Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbXLSUvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbXLSUvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbXLSUvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:51:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57736 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbXLSUve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:51:34 -0500
Message-ID: <4769844F.4030902@redhat.com>
Date: Wed, 19 Dec 2007 15:51:27 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: "Gosney, JeremiX" <jeremix.gosney@intel.com>
CC: linux-kernel@vger.kernel.org, "Peters, Gordon" <gordon.peters@intel.com>,
       "Sy, Dely L" <dely.l.sy@intel.com>
Subject: Re: ARP Bug?
References: <F2B6B9EAC551DA4AA8833629D55D9CA8482D4C@orsmsx418.amr.corp.intel.com>
In-Reply-To: <F2B6B9EAC551DA4AA8833629D55D9CA8482D4C@orsmsx418.amr.corp.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2007 08:11 PM, Gosney, JeremiX wrote:
> We've noticed the 2.6-based Linux systems in our test lab are
> experiencing some "ARP flux"-like symptoms.  
> 
> The systems reply with eth0's hardware address to all ARP requests,
> regardless of the IP being queried.  Because of this, the system will
> only send and receive packets on eth0; if eth0 is brought down, the
> system is unreachable even though it still has several active
> connections.  With eth0 unplugged, none of the other interfaces are
> reachable (this is presumably a side-effect caused by the switch ARP
> cache.) Failover routes are defined in the routing table, but the system
> still will not send/receive packets out those interfaces.
> 
> Can anything be done to correct this behaviour?
> 
> 

Offtopic here, but anyway look at http://linux-ip.net/html/ch-ether.html

