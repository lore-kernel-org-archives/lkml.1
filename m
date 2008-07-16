Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbYGQPnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbYGQPnG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755726AbYGQPmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:42:55 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:57694 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbYGQPmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:42:54 -0400
Cc: Dave Jones <davej@redhat.com>, linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       akpm <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Message-Id: <C353D587-E029-4C80-A703-D23A8FA889A8@freescale.com>
From: Kumar Gala <kumar.gala@freescale.com>
To: benh@kernel.crashing.org
In-Reply-To: <1216184495.7740.158.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [git pull] Please pull from powerpc.git merge branch
Date: Wed, 16 Jul 2008 07:46:18 -0500
References: <1216172043.7740.136.camel@pasglop> <20080716042042.GA13212@redhat.com> <1216184495.7740.158.camel@pasglop>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 16, 2008, at 12:01 AM, Benjamin Herrenschmidt wrote:

> On Wed, 2008-07-16 at 00:20 -0400, Dave Jones wrote:
>> On Wed, Jul 16, 2008 at 11:34:03AM +1000, Ben Herrenschmidt wrote:
>>> Linus,
>>>
>>> I apologize in advance for the couple of merge commits in there. I
>>> merged your tree yesterday in order to fix a (fairly minor)  
>>> conflict,
>>> and waited for our autobuilder to test a whole bunch of configs
>>> overnight before asking you to pull, at which point, sfr informed  
>>> me of
>>> a bunch of this time non-trivial conflicts with whatever you  
>>> pulled in
>>> the meantime...
>>>
>>> So here it is with 2 merge csets at the top, I'll try to do better  
>>> next
>>> time. I don't want to rebase or my sub-maintainers will hate me.
>>>
>>> So please pull from:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge
>>
>> Boom!
>>
>> arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
>> /builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/ 
>> platforms/82xx/ep8248e.c:129: undefined reference to  
>> `alloc_mdio_bitbang'
>> /builddir/build/BUILD/kernel-2.6.26/linux-2.6.26.ppc/arch/powerpc/ 
>> platforms/82xx/ep8248e.c:143: undefined reference to  
>> `mdiobus_register'
>>
>> .config is at http://davej.fedorapeople.org/kernel-2.6.27-ppc.config
>
> Kumar, I think that's your realm, what's up there ?

I'll look into this.  On the note I'd like to add a ppc6xx_defconfig  
and use the defconfig from Dave as the starts of that.  Any objections?

- k
