Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbYDOV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbYDOV5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760750AbYDOV5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:57:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:53679 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754415AbYDOV5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:57:11 -0400
Subject: Re: Microblaze Linux release
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: monstr@seznam.cz, Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       paulus@samba.org
In-Reply-To: <200804151532.11619.arnd@arndb.de>
References: <48020A21.4000404@seznam.cz> <200804140801.57464.arnd@arndb.de>
	 <4804A59B.5040909@seznam.cz>  <200804151532.11619.arnd@arndb.de>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 07:52:38 +1000
Message-Id: <1208296358.6958.237.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-15 at 15:32 +0200, Arnd Bergmann wrote:
> 
> I'd recommend splitting prom.c into code that can be shared between powerpc
> and microblaze and architecture specific code. Anything that deals with
> LMB should go into powerpc, and you can simply use the alloc_bootmem
> mechanism for your architecture.

That is non trivial... the unflatten DT code among others relies heavily
on the LMB's to allocate the objects.

We could split the early accessors, unflatten code, and kernel-side
accessors at one point, though we already did most of it no ?

Ben.


