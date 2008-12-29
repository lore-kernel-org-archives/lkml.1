Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYL2Egn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYL2Egn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 23:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYL2Egc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 23:36:32 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:55782 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYL2Egb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 23:36:31 -0500
Message-ID: <495853C6.6030000@oracle.com>
Date: Sun, 28 Dec 2008 20:36:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: netdev@vger.kernel.org, sean.hefty@intel.com
Subject: 2.6.28-git1 build failure
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.495853C9.00AF:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/built-in.o: In function `addr_resolve_remote':
addr.c:(.text+0x12fe75): undefined reference to `ip6_route_output'
drivers/built-in.o: In function `rdma_translate_ip':
(.text+0x1301a7): undefined reference to `ipv6_chk_addr'
drivers/built-in.o: In function `rdma_resolve_ip':
(.text+0x1303a9): undefined reference to `ipv6_chk_addr'
drivers/built-in.o: In function `rdma_resolve_ip':
(.text+0x13051b): undefined reference to `ip6_route_output'

when CONFIG_IPV6=n.

-- 
~Randy
