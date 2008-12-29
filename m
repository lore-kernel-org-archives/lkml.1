Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYL2Ui2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYL2Ui2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYL2Ufg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:35:36 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:20961 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbYL2Ufb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:35:31 -0500
Date: Mon, 29 Dec 2008 12:35:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       kxie@chelsio.com
Subject: Re: linux-next: Tree for December 29 (cxgb3i)
Message-Id: <20081229123517.23fd6169.randy.dunlap@oracle.com>
In-Reply-To: <20081230031621.60acd90b.sfr@canb.auug.org.au>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.49593488.0220:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008 03:16:21 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20081219:
> 
> Undropped tree:
> 	scci
> 	mtd
> 
> Dropped trees (temporarily):
> 	nfs (akpm request due to 2.6.30 features)
> 	kvm (build problem)
> 	rr (build poblem)
> 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> 	cpu_alloc (build problem)
> 	audit (difficult conflicts)
> 
> Linus' tree had three build failures requiring patches and one requiring
> a revert.


linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:499: error: 'struct sk_buff' has no member named 'sp'
linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:512: error: 'struct sk_buff' has no member named 'sp'
linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:532: error: 'struct sk_buff' has no member named 'sp'
linux-next-20081229/drivers/scsi/cxgb3i/cxgb3i_offload.c:533: error: 'struct sk_buff' has no member named 'sp'


---
~Randy
