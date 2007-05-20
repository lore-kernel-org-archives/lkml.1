Return-Path: <linux-kernel-owner+w=401wt.eu-S1762400AbXETKBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762400AbXETKBt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 06:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbXETKBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 06:01:42 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:56015 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156AbXETKBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 06:01:41 -0400
Date: Sun, 20 May 2007 12:01:06 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jan Glauber <jan.glauber@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: building i386 requires s390: "driver/crypto/Kconfig" sourcing s390 arch
Message-ID: <20070520100106.GB9892@osiris.ibm.com>
References: <464DFF5F.5010905@tlinx.org> <20070518141735.aae3921a.randy.dunlap@oracle.com> <464E1E9A.8060605@tlinx.org> <20070518161920.ae0ed062.randy.dunlap@oracle.com> <464E9D69.8030505@tlinx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464E9D69.8030505@tlinx.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 11:47:05PM -0700, Linda Walsh wrote:
> Randy Dunlap wrote:
> >if S390
> >source "arch/s390/crypto/Kconfig"
> >endif
> >  
> Why bother?  Why not just move the contents of s390's crypto "Kconfig"
> in place of the "source" statement.  All the options in s390's Kconfig
> are already conditional depending on S390.
> 
> The contents simply need to be [moved] in[to] the the main crypto
> config file (./drivers/crypto/Kconfig).
> 
> It "works" fine on i386, don't see why it wouldn't build on any other
> arch.

Send a patch.
