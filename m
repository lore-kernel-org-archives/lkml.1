Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbZKQWTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbZKQWTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbZKQWTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:19:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:56614 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756292AbZKQWTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:19:48 -0500
Date: Tue, 17 Nov 2009 23:19:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?=22Andr=E9_Goddard_Rosa=22?= 
	<andre.goddard@gmail.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: manual merge of the trivial tree with the pci tree
In-Reply-To: <20091117155417.e0514040.sfr@canb.auug.org.au>
Message-ID: <alpine.LSU.2.00.0911172318340.15039@wotan.suse.de>
References: <20091117155417.e0514040.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1210159433-1258496393=:15039"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1210159433-1258496393=:15039
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Tue, 17 Nov 2009, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> arch/x86/pci/amd_bus.c between commit
> 99935a7a59eaca0292c1a5880e10bae03f4a5e3d ("x86/PCI: read root resources
> from IOH on Intel") from the pci tree and commit
> 17530b1c635dfd1f258afc6b07b986b425d66ebd ("tree-wide: fix assorted typos
> all over the place") from the trivial tree.
> 
> The comment fixed up by the trivial tree patch has moved to
> arch/x86/pci/bus_numa.h and I haven't bothered to fix it there.

Thanks for letting me know.

I have dropped the hunk from my queue. Jesse, could you please merge this 
patch to your tree instead?




From: André Goddard Rosa <andre.goddard@gmail.com>
Subject: pci: fix comment typo

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 572ee97..575f6fe 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -19,7 +19,7 @@
 
 /*
  * sub bus (transparent) will use entres from 3 to store extra from root,
- * so need to make sure have enought slot there, increase PCI_BUS_NUM_RESOURCES?
+ * so need to make sure have enough slot there, increase PCI_BUS_NUM_RESOURCES?
  */
 #define RES_NUM 16
 struct pci_root_info {
--168427776-1210159433-1258496393=:15039--
