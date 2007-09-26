Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbXIZGDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbXIZGDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 02:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbXIZGC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 02:02:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47489
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbXIZGC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 02:02:58 -0400
Date: Tue, 25 Sep 2007 23:02:51 -0700 (PDT)
Message-Id: <20070925.230251.120461813.davem@davemloft.net>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: kamalesh@linux.vnet.ibm.com
Subject: Re: + git-net-fix-pasemi_mac.patch added to -mm tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <200709242233.l8OMXsL5021125@imap1.linux-foundation.org>
References: <200709242233.l8OMXsL5021125@imap1.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: akpm@linux-foundation.org
Date: Mon, 24 Sep 2007 15:33:54 -0700

> Subject: git-net: fix pasemi_mac
> From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> 
> drivers/net/pasemi_mac.c: In function $,1rx(Bpasemi_mac_probe$,1ry(B:
> drivers/net/pasemi_mac.c:1153: error: conflicting types for $,1rx(Bmac$,1ry(B
> drivers/net/pasemi_mac.c:1151: error: previous declaration of $,1rx(Bmac$,1ry(B was here
> drivers/net/pasemi_mac.c:1170: error: incompatible types in assignment
> drivers/net/pasemi_mac.c:1172: error: request for member $,1rx(Bpdev$,1ry(B in
> something not a structure or union
> 
> In the function
> static int __devinit
> pasemi_mac_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> {
> <snip>
> struct pasemi_mac *mac;
> int err;
> DECLARE_MAC_BUF(mac);
> 
> introduction of mac as var [18] triggers the build failure, so in the below
> patch renaming mac as mac_buf is done, because it is used to print the mac
> address using the newly introduced print_mac function.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Applied to net-2.6.24, thanks!
