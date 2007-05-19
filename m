Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbXESGrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbXESGrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 02:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXESGrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 02:47:11 -0400
Received: from ishtar.tlinx.org ([64.81.245.74]:54987 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbXESGrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 02:47:11 -0400
Message-ID: <464E9D69.8030505@tlinx.org>
Date: Fri, 18 May 2007 23:47:05 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: building i386 requires s390: "driver/crypto/Kconfig" sourcing
 s390 arch
References: <464DFF5F.5010905@tlinx.org>	<20070518141735.aae3921a.randy.dunlap@oracle.com>	<464E1E9A.8060605@tlinx.org> <20070518161920.ae0ed062.randy.dunlap@oracle.com>
In-Reply-To: <20070518161920.ae0ed062.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> if S390
> source "arch/s390/crypto/Kconfig"
> endif
>   
Why bother?  Why not just move the contents of s390's crypto "Kconfig"
in place of the "source" statement.  All the options in s390's Kconfig
are already conditional depending on S390.

The contents simply need to be [moved] in[to] the the main crypto
config file (./drivers/crypto/Kconfig).

It "works" fine on i386, don't see why it wouldn't build on any other
arch.



