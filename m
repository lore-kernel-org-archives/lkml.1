Return-Path: <linux-kernel-owner+w=401wt.eu-S1761541AbYDPGXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761541AbYDPGXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 02:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYDPGXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 02:23:06 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:33024 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYDPGXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 02:23:04 -0400
Message-ID: <48059B92.7080601@seznam.cz>
Date: Wed, 16 Apr 2008 08:24:18 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: benh@kernel.crashing.org
Cc: Arnd Bergmann <arnd@arndb.de>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       paulus@samba.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <200804140801.57464.arnd@arndb.de>	 <4804A59B.5040909@seznam.cz>  <200804151532.11619.arnd@arndb.de> <1208296358.6958.237.camel@pasglop>
In-Reply-To: <1208296358.6958.237.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ben,

>> I'd recommend splitting prom.c into code that can be shared between powerpc
>> and microblaze and architecture specific code. Anything that deals with
>> LMB should go into powerpc, and you can simply use the alloc_bootmem
>> mechanism for your architecture.
> 
> That is non trivial... the unflatten DT code among others relies heavily
> on the LMB's to allocate the objects.

I think so. Sharing code among archs looks nice and this way is definitely
right. But starting with communication with PowerPC guys that this code I want
to use in case that this code is not in vanilla. This is not good start for
doing this.
I think if Microblaze will be in vanilla we can talked about separation MB and
PPC part to kernel folder and shared code move to shared folder.

> We could split the early accessors, unflatten code, and kernel-side
> accessors at one point, though we already did most of it no ?

Yes

Michal Simek
www.monstr.eu
