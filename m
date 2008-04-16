Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbYDPHtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbYDPHtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 03:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYDPHs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 03:48:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:39955 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbYDPHs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 03:48:56 -0400
Subject: Re: Microblaze Linux release
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: monstr@seznam.cz
Cc: Arnd Bergmann <arnd@arndb.de>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       paulus@samba.org
In-Reply-To: <48059B92.7080601@seznam.cz>
References: <48020A21.4000404@seznam.cz> <200804140801.57464.arnd@arndb.de>
	 <4804A59B.5040909@seznam.cz>  <200804151532.11619.arnd@arndb.de>
	 <1208296358.6958.237.camel@pasglop>  <48059B92.7080601@seznam.cz>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 17:45:58 +1000
Message-Id: <1208331959.6958.272.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-16 at 08:24 +0200, Michal Simek wrote:
> Hi Ben,
> 
> >> I'd recommend splitting prom.c into code that can be shared between powerpc
> >> and microblaze and architecture specific code. Anything that deals with
> >> LMB should go into powerpc, and you can simply use the alloc_bootmem
> >> mechanism for your architecture.
> > 
> > That is non trivial... the unflatten DT code among others relies heavily
> > on the LMB's to allocate the objects.
> 
> I think so. Sharing code among archs looks nice and this way is definitely
> right. But starting with communication with PowerPC guys that this code I want
> to use in case that this code is not in vanilla. This is not good start for
> doing this.
> I think if Microblaze will be in vanilla we can talked about separation MB and
> PPC part to kernel folder and shared code move to shared folder.

Well, LMB code is moving to generic anyway... So we may as well move
more stuff there ;-)

Cheers,
Ben.


