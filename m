Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbXIDKaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbXIDKaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 06:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXIDK37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 06:29:59 -0400
Received: from mail.gmx.net ([213.165.64.20]:42535 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752857AbXIDK37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 06:29:59 -0400
X-Authenticated: #12383568
X-Provags-ID: V01U2FsdGVkX1/nRpgIiNfn6urZXt2bveWRW3Tb95ASiSOPrBt+IK
	+1uKxSnaAOD5Xw
From: Clemens Kolbitsch <clemens.kol@gmx.at>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Subject: Re: Forbid deletion of memory mappings
Date: Tue, 4 Sep 2007 12:29:55 +0200
User-Agent: KMail/1.9.6
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
References: <200708301844.10532.clemens.kol@gmx.at> <200708310005.53587.clemens.kol@gmx.at> <46DD30CC.4060907@aitel.hist.no>
In-Reply-To: <46DD30CC.4060907@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709041229.55610.clemens.kol@gmx.at>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> If you are doing research, consider these methods:
> 1. Change vma_merge() so it always fail to merge mappings
>
> or
>
> 2. Set up your "mappings duplicated in userspace" so
>     they too merge in the same way.
>
> Helge Hafting

Hi!
Thanks for your answer, however you (too) misunderstood: Merging of the vma's 
is not the problem and I understand why the kernel does so.

The real problem is that it deletes mappings it should not be deleting... in 
my case, I've found out that a possible reason for the deletions is that the 
stack tries to grow or other large areas of memory are allocated and my 
mapping is taking up the memory that the kernel wants to reserve.

However, this has been dealt with in some other reply - I decided to simply 
relocate my mappings to another memory area as soon as the kernel tries to 
delete them.

This is not really all that efficient, but it does not matter right now in my 
case.

Thanks again for your answer - I appreciate it!




