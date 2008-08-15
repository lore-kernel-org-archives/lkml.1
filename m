Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbYHOWLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbYHOWLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbYHOWLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:11:42 -0400
Received: from xenotime.net ([66.160.160.81]:55621 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755947AbYHOWLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:11:40 -0400
Date: Fri, 15 Aug 2008 08:41:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, mchan@broadcom.com,
       netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-Id: <20080815084116.340ac526.randy.dunlap@oracle.com>
In-Reply-To: <20080815184032.3acd8032.sfr@canb.auug.org.au>
References: <20080815184032.3acd8032.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: linux-next: Tree for August 15 (bnx2) [resend/lost]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When VLAN is not enabled, bnx2 build fails with:

drivers/net/bnx2.c: In function 'bnx2_rx_int':
drivers/net/bnx2.c:2959: error: dereferencing pointer to incomplete type
drivers/net/bnx2.c:2960: error: dereferencing pointer to incomplete type
make[2]: *** [drivers/net/bnx2.o] Error 1


on these lines:

				ve->h_vlan_proto = htons(ETH_P_8021Q);
				ve->h_vlan_TCI = htons(vtag);


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
