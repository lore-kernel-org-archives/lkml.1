Return-Path: <linux-kernel-owner+w=401wt.eu-S1763895AbYDPPZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763895AbYDPPZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbYDPPZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:25:12 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:45471 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816AbYDPPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:25:11 -0400
Message-ID: <48061AA0.2000305@seznam.cz>
Date: Wed, 16 Apr 2008 17:26:24 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
Cc: benh@kernel.crashing.org, Arnd Bergmann <arnd@arndb.de>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz>	<200804140801.57464.arnd@arndb.de>	<4804A59B.5040909@seznam.cz>	<200804151532.11619.arnd@arndb.de>	<1208296358.6958.237.camel@pasglop>	<48059B92.7080601@seznam.cz> <18437.43836.175638.137415@cargo.ozlabs.ibm.com>
In-Reply-To: <18437.43836.175638.137415@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> 
>> I think so. Sharing code among archs looks nice and this way is definitely
>> right. But starting with communication with PowerPC guys that this code I want
>> to use in case that this code is not in vanilla. This is not good start for
>> doing this.
> 
> I have a commit queued up that moves lmb.c into the top-level lib
> directory so other architectures can use it easily.  Dave Miller
> wanted this so he could use it for sparc64.  That will go into Linus'
> tree when the merge window opens and will be in 2.6.26.  So I don't
> see any reason why microblaze couldn't use the LMB stuff.
> 
> Paul.

I will test it.

Thanks Paul,

Michal Simek

