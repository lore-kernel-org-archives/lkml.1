Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbYDNHO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbYDNHO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759644AbYDNHOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:14:50 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:53436 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754324AbYDNHOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:14:49 -0400
Message-ID: <4803035D.5030400@seznam.cz>
Date: Mon, 14 Apr 2008 09:10:21 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       benh@kernel.crashing.org, John Linn <John.Linn@xilinx.com>,
       git-dev@xilinx.com, Grant Likely <grant.likely@secretlab.ca>,
       git@xilinx.com, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <200804140538.30268.arnd@arndb.de>
In-Reply-To: <200804140538.30268.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

>> I would like to ask you for review all microblaze code especially
>> arch/microblaze and include/asm-microblaze. Please don't send me question to
>> drivers - Microblaze will use only uartlite driver (only add on or to Kconfig -
>> that's enough for now).
> 
> I'm certainly willing to help review it, but I think the timing is too short
> for asking for a 2.6.26 merge. Judging from experience, a new architecture
> review takes a few weeks to sort out all the issues you want resolved before
> merging, so posting them now would put you in a much more comfortable position
> when targeting a 2.6.27 merge.

Thanks for your help. I know that the time is short.:-( We'll see. I will
request for merge if I know Microblaze cpu is clean.

> One of the things I always wanted to have is a common location for all the
> things that get duplicated verbatim into each new architecture, like all
> the include/asm/{fcntl,ioctls,ipcbuf,mman,poll,posix_types,sem_buf}.h and
> others that define part of the syscall ABI.
> 
> 	Arnd <><

Include files are pain I know.

Michal Simek
www.monstr.eu
