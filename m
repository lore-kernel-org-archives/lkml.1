Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYK1Rzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYK1Rzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 12:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYK1RzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 12:55:22 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:57800 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYK1RzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 12:55:21 -0500
Message-ID: <4930307C.30106@oracle.com>
Date: Fri, 28 Nov 2008 09:55:08 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for November 28 (misc/tc1100)
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
In-Reply-To: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4930307F.003F:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20081127:
> 
> Today's tree fails the powerpc allyesconfig build.
> 
> New tree:
> 	trivial
> 
> Undropped trees:
> 
> Dropped trees (temporarily):
> 	v4l-dvb (build problem)
> 	kbuild (build problem)
> 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> 	cpu_alloc (build problem)
> 	perfmon3 (concerns from the x86 team)

make[2]: *** No rule to make target `drivers/misc/tc1100-wmi.o', needed by `drivers/misc/built-in.o'.

on allmodconfig & allyesconfig for i386.

On, moved to drivers/x86/.  Someone needs to clean up drivers/misc/Makefile.

-- 
~Randy
