Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbZDNMpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbZDNMpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbZDNMpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:45:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:2898 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbZDNMpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:45:43 -0400
Message-ID: <49E48573.5010604@petalogix.com>
Date: Tue, 14 Apr 2009 14:45:39 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       lkml <linux-arch@vger.kernel.org>, microblaze-uclinux@itee.uq.edu.au,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Williams <john.williams@petalogix.com>,
       John Linn <John.Linn@xilinx.com>,
       Stephen Neuendorffer <stephenn@xilinx.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Korsgaard <jacmet@sunsite.dk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [GIT PULL, v3] Microblaze architecture (arch/microblaze/) support
References: <49DC4024.6090800@petalogix.com> <alpine.LFD.2.00.0904131818050.26713@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904131818050.26713@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Wed, 8 Apr 2009, Michal Simek wrote:
>   
>> This repository contains Linux support for Xilinx Microblaze CPU.
>>
>> Please pull
>>     git://git.monstr.eu/linux-2.6-microblaze.git for-linus
>>     
>
> So I pulled, but I notice that there's a few empty header files.
>   
Thanks.
> That looks intentional (they came in through a commit that says "headers 
> simple files - empty or redirect to asm-generic"), but it means that "make 
> distclean" will remove them. So if you really want an empty header file, 
> you should really make it not _completely_ empty - add a comment to it or 
> something.
>   
I have just sent you request with Microblaze fixes. As Ingo wrote in
LKML is the patch which fixed problem
with some empty header files (this patch is in include in my request
too). In my request pull are another simple changes
which solve some compilation bugs for Microblaze which comes from merge
windows.

Thanks,
Michal

> 		Linus
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

