Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbYDPP1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbYDPP1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 11:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757673AbYDPP1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 11:27:39 -0400
Received: from service1.sh.cvut.cz ([147.32.127.214]:39149 "EHLO
	service1.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbYDPP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:27:39 -0400
X-Spam-Score: -102.141
Message-ID: <48061B36.20800@seznam.cz>
Date: Wed, 16 Apr 2008 17:28:54 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <48059B92.7080601@seznam.cz> <18437.43836.175638.137415@cargo.ozlabs.ibm.com> <200804160944.42734.arnd@arndb.de>
In-Reply-To: <200804160944.42734.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> I think so. Sharing code among archs looks nice and this way is definitely
>>> right. But starting with communication with PowerPC guys that this code I want
>>> to use in case that this code is not in vanilla. This is not good start for
>>> doing this.
>> I have a commit queued up that moves lmb.c into the top-level lib
>> directory so other architectures can use it easily.  Dave Miller
>> wanted this so he could use it for sparc64.  That will go into Linus'
>> tree when the merge window opens and will be in 2.6.26.  So I don't
>> see any reason why microblaze couldn't use the LMB stuff.
>>
>
> Right, fair enough. I was mostly objecting to the idea of creating another
> copy of the lmb code when bootmem should be sufficient for what microblaze
> needs. Using the code from lib/lmb.c sounds fair enough when it's already
> there.
>
> One more reason for the microblaze kernel to base on top of linux-next
> instead of mainline.

For me is not difficult to use lmb from microblaze/mm or from lib if the files
are the same.

Michal Simek
