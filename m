Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab0CEBTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 20:19:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54864 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab0CEBTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 20:19:17 -0500
Date: Thu, 4 Mar 2010 20:19:17 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Upstream first policy
Message-ID: <20100305011917.GH12443@bombadil.infradead.org>
References: <20100304103929.6eb81d45@jbarnes-piketon> <alpine.LFD.2.00.1003041047400.3751@localhost.localdomain> <20100304105624.70fe845e@jbarnes-piketon> <alpine.LFD.2.00.1003041101390.3751@localhost.localdomain> <21d7e9971003041125x1aee3b3ew1e407ca6695e10fc@mail.gmail.com> <alpine.LFD.2.00.1003041142250.3751@localhost.localdomain> <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com> <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain> <1267748927.3496.6.camel@nisroch> <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 04:41:19PM -0800, Linus Torvalds wrote:
> That fact was what made it so important to get it merged. The distro rules 
> wrt the kernel have been (for _years_ - before nouveau was ever even used 
> by Fedora) that whole "upstream first".
> 

As nice as that is, I'm not sure *any* real distro follows it. (Ok,
Gentoo seems to only ship ~100K of diff in their genpatches dir[1],
good on them.)

We *try* to only merge things in Fedora that will be heading upstream
quickly, or are backports from -next. Things occasionally, you know,
don't, like the execshield crap, lirc, and utrace.

Nouveau, you obviously know about, I think Adam merged it into Fedora
for the sole reason of providing a slightly less crap experience for
Nvidia cards prior to G80 where the nv driver got slightly better.
(Though, obviously Nouveau is now compelling for more reasons than just
being able to light up a second head.) This is obviously now more
difficult now that nouveau binds by default on boot with KMS.

It would be /great/ if we had more people cleaning up staging drivers
so that more stuff could go in there. But it seems people are more
interested in re-indenting code than actually fixing things. (I can
understand a certain reticence to this, since it's sometimes hard to fix
real problems in drivers if you can't test it.) I'm not sure what the
latest round of staging changes looks like off hand, but I'm going to
guess that more stuff was punted for unmaintenance than graduated to the
kernel proper by a large factor.

regards, Kyle

I recommend you don't look at Ubuntu, we might have a lot of extra
crud[2] in the kernel if you do. :) (Actually, shockingly less than I
thought, just apparmor, aufs, ndiswrapper are the obvious ones.)

1. http://dev.gentoo.org/~mpagano/genpatches/trunk/2.6.32/
2.
http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-lucid.git;a=tree;f=ubuntu
