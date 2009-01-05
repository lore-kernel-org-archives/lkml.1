Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbZAERqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbZAERqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZAERqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:46:11 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:26051 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbZAERqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:46:09 -0500
Date: Mon, 5 Jan 2009 09:45:37 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, dm-devel@redhat.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for January 5 (dm-target)
Message-Id: <20090105094537.0718183d.randy.dunlap@oracle.com>
In-Reply-To: <20090105173517.deeff918.sfr@canb.auug.org.au>
References: <20090105173517.deeff918.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.49624746.00B6:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 17:35:17 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> This tree will not build a powerpc ppc4xx_defconfig due to a kvm problem.
> 
> Changes since 20090102:
> 
> Removed tree:
> 	rr_cpumask (served it purpose)
> 
> Undropped tree:
> 	driver-core
> 	kvm
> 
> Dropped trees (temporarily):
> 	usb (build problem)
> 	rr (complex conflicts)
> 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> 	cpu_alloc (build problem)
> 	audit (difficult conflicts)
> 	staging (depends on usb)
> 
> The device-mapper tree lost its conflict.


When CONFIG_MODULE_UNLOAD=n (or CONFIG_MODULES=n):

linux-next-20090105/drivers/md/dm-target.c:106: error: implicit declaration of function 'module_refcount'



---
~Randy
