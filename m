Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbXLJRgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbXLJRgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 12:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbXLJRgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 12:36:09 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:40083 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbXLJRgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 12:36:08 -0500
Message-ID: <475D7901.1040900@nortel.com>
Date: Mon, 10 Dec 2007 11:36:01 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: "ip neigh show" not showing arp cache entries?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2007 17:36:04.0832 (UTC) FILETIME=[23C24E00:01C83B53]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm seeing some strange behaviour on a 2.6.14 ppc64 system.  If I run 
"ip neigh show" it prints out nothing, but if I run "arp" then I see the 
other nodes on the local network.


root@base0-0-0-5-0-11-1:/root> ip neigh show
root@base0-0-0-5-0-11-1:/root> arp -n
Address                  HWtype  HWaddress           Flags Mask 
    Iface
172.24.132.0             ether   00:01:AF:14:E8:DA   C 
    bond0
172.24.132.1                     (incomplete) 
    bond0
172.24.136.0             ether   00:C0:8B:07:B3:7E   C 
    bond0
172.24.132.4             ether   00:01:AF:14:E8:DA   C 
    bond0
172.24.132.2             ether   00:01:AF:14:E8:DA   C 
    bond0


Any ideas what's going on here?

Thanks,

Chris
