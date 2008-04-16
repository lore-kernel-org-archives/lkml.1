Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYDPHbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYDPHbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 03:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYDPHbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 03:31:15 -0400
Received: from ozlabs.org ([203.10.76.45]:52693 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYDPHbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 03:31:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18437.43836.175638.137415@cargo.ozlabs.ibm.com>
Date: Wed, 16 Apr 2008 17:31:08 +1000
From: Paul Mackerras <paulus@samba.org>
To: monstr@seznam.cz
Cc: benh@kernel.crashing.org, Arnd Bergmann <arnd@arndb.de>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: Microblaze Linux release
In-Reply-To: <48059B92.7080601@seznam.cz>
References: <48020A21.4000404@seznam.cz>
	<200804140801.57464.arnd@arndb.de>
	<4804A59B.5040909@seznam.cz>
	<200804151532.11619.arnd@arndb.de>
	<1208296358.6958.237.camel@pasglop>
	<48059B92.7080601@seznam.cz>
X-Mailer: VM 7.19 under Emacs 22.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek writes:

> I think so. Sharing code among archs looks nice and this way is definitely
> right. But starting with communication with PowerPC guys that this code I want
> to use in case that this code is not in vanilla. This is not good start for
> doing this.

I have a commit queued up that moves lmb.c into the top-level lib
directory so other architectures can use it easily.  Dave Miller
wanted this so he could use it for sparc64.  That will go into Linus'
tree when the merge window opens and will be in 2.6.26.  So I don't
see any reason why microblaze couldn't use the LMB stuff.

Paul.
