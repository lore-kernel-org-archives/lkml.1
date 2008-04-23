Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYDWVHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYDWVHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYDWVHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:07:37 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:36438 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYDWVHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:07:36 -0400
Message-ID: <480FA565.2000608@seznam.cz>
Date: Wed, 23 Apr 2008 23:08:53 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <480FA235.8000203@seznam.cz> <200804232257.04060.florian.fainelli@telecomint.eu> <200804232301.46764.arnd@arndb.de>
In-Reply-To: <200804232301.46764.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am decided to remove content pci.h and pci-bridge.h. It is easier for me now.
This step comes soon. I gonna change consistent.c file with use it.

The files will be in asm folder because OF point to them but the files will be
empty or almost empty.

Regards,
Michal Simek



>> While reading the previous discussion, I wondered that keeping PCI would be a 
>> good idea. I am personnaly using it for a custom design and would be glad 
>> being able to continue using it.
>>
>> If this represents too much work for you, we can probably add it later.
>>
> 
> The problem as far as I can see is that the existing header files
> just don't work without a platform implementation.
> 
> I think it would be less confusing to leave them out. If you 
> need PCI, it's probably easier to add new files for these
> and get them working at the same time.
> 
> 	Arnd <><
> 
> 
