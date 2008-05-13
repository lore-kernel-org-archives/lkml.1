Return-Path: <linux-kernel-owner+w=401wt.eu-S1760599AbYEMOiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760599AbYEMOiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757607AbYEMOir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:38:47 -0400
Received: from trantor.org.uk ([213.146.130.142]:60613 "EHLO
	trantor.trantor.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461AbYEMOiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:38:46 -0400
Subject: Re: oprofile BUG() in current kernel.
From: Gianni Tedesco <gxt@cs.nott.ac.uk>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, arges@linux.vnet.ibm.com,
       Maynard Johnson <maynardj@us.ibm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net, Mike Travis <travis@sgi.com>
In-Reply-To: <482986B3.1090601@cosmosbay.com>
References: <1210593756.3708.7.camel@dao.KWGR614>
	 <19f34abd0805120519t12fceef9u7870006a904c85b2@mail.gmail.com>
	 <1210599105.3479.1.camel@dao.KWGR614> <48285002.9080702@us.ibm.com>
	 <1210610283.7218.4.camel@snuffleupagus>
	 <20080513014010.e0723e01.akpm@linux-foundation.org>
	 <1210671688.3472.10.camel@dao.KWGR614>  <48296C96.8060000@cosmosbay.com>
	 <1210676392.3939.4.camel@dao.KWGR614>  <482986B3.1090601@cosmosbay.com>
Content-Type: text/plain
Date: Tue, 13 May 2008 15:38:38 +0100
Message-Id: <1210689518.3724.4.camel@dao.KWGR614>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 14:16 +0200, Eric Dumazet wrote:
> It fixes the bug here for me.
> 
> Did you rebuild your modules and "make modules_install" them ?
> 
> Please make sure oprofile.ko only includes .data.percpu
> 
> # size -A 
> /lib/modules/2.6.26-rc2-00051-gc714a53-dirty/kernel/arch/x86/oprofile/oprofile.ko
> /lib/modules/2.6.26-rc2-00051-gc714a53-dirty/kernel/arch/x86/oprofile/oprofile.ko  
> :
> section                      size   addr
[snip]
> .data                        1328      0
> .data.percpu                  124      0
> .gnu.linkonce.this_module    4480      0
> .bss                          372      0
> .comment                      288      0
> .note.GNU-stack                 0      0
> Total                       19997

Oops, how embarrassing. I applied the patch manually and missed out the
first chunk. Disregard previous post. This fixes the problem for me.

Good work one and all :)

