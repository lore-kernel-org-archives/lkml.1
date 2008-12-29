Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbYL2Ubj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbYL2Ubj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYL2Ub3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:31:29 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:23146 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbYL2Ub2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:31:28 -0500
Date: Mon, 29 Dec 2008 12:31:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 29 (fcoe)
Message-Id: <20081229123115.9a255fa8.randy.dunlap@oracle.com>
In-Reply-To: <20081230031621.60acd90b.sfr@canb.auug.org.au>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49593396.00E1:SCFSTAT928724,ss=1,fgs=0
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


linux-next-20081229/drivers/scsi/fcoe/libfcoe.c:995: error: dereferencing pointer to incomplete type
linux-next-20081229/drivers/scsi/fcoe/libfcoe.c:1015: error: dereferencing pointer to incomplete type

(on netdev->name ?)


Also, libfoce.c has 2 printk's that say "foce:" instead of "fcoe:"...

---
~Randy
