Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbYJZHUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbYJZHUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 03:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYJZHUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 03:20:04 -0400
Received: from fwil.voltaire.com ([193.47.165.2]:49001 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751037AbYJZHUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 03:20:03 -0400
Message-ID: <49041A1F.3070806@voltaire.com>
Date: Sun, 26 Oct 2008 09:19:59 +0200
From: Or Gerlitz <ogerlitz@voltaire.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, ericvh@gmail.com,
       rolandd@cisco.com, v9fs-developer@lists.sourceforge.net,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: linux-next: Tree for October 23
References: <20081023213637.eff9b414.sfr@canb.auug.org.au> <20081023180412.394d40c2.randy.dunlap@oracle.com>
In-Reply-To: <20081023180412.394d40c2.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Oct 2008 07:19:59.0480 (UTC) FILETIME=[414AF780:01C9373B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Building with CONFIG_INFINIBAND=m, kconfig allows CONFIG_NET_9P_RDMA=m,
> so one module wants symbols from the other (net/9p wants symbols from rmda_*).
>
> ERROR: "rdma_destroy_id" [net/9p/9pnet_rdma.ko] undefined!
> ERROR: "rdma_connect" [net/9p/9pnet_rdma.ko] undefined!
> ...
> Is this supposed to be allowed/possible?  Otherwise NET_9P_RDMA might have to depend on INFINBAND=y...
No, there's no need to config INFINIBAND at built it.  What's the value 
of CONFIG_INFINIBAND_ADDR_TRANS ?

Or.


