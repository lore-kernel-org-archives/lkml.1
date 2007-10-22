Return-Path: <linux-kernel-owner+w=401wt.eu-S1753561AbXJVGnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbXJVGnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 02:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXJVGnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:43:12 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:59693 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbXJVGnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:43:11 -0400
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>, Jeff Dike <jdike@addtoit.com>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
References: <200710111754.46854.rob@landley.net>
	<200710200252.37919.p.giarrusso@gmail.com>
	<87y7dyhv2u.fsf@hades.wkstn.nix> <20071021114854.GF2455@hacking>
	<20071021130848.GA4621@c2.user-mode-linux.org>
	<20071021132031.GI2455@hacking>
	<20071021154346.GW8181@ftp.linux.org.uk>
	<20071022043746.GF2998@hacking>
	<20071022052214.GY8181@ftp.linux.org.uk>
	<20071022061245.GG2998@hacking>
From: Nix <nix@esperi.org.uk>
Emacs: the definitive fritterware.
Date: Mon, 22 Oct 2007 07:42:33 +0100
In-Reply-To: <20071022061245.GG2998@hacking> (WANG Cong's message of "Mon, 22 Oct 2007 14:12:46 +0800")
Message-ID: <87d4v7fy5i.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-sonic.net-Metrics: hades 1156; Body=7 Fuz1=7 Fuz2=7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Oct 2007, WANG Cong uttered the following:
> I build UML for non-SMP x86. But I don't know about UML_NET_VDE. ;(
>
> Errors threw out by gcc (too many) are put here:
> 	http://wangcong.org/down/errors.txt

It's hard to tell without LOCALE=C, but those are the sorts of results
I'd expect if you had run make {old,menu,x}config without specifying
ARCH=um, so you've configured for one architecture and are now trying
to build another.

Where is the include/asm symlink pointing to in your build tree?

(FWIW I get a coredump if I try to use the skas patch, but with noprocmm
UML in 2.6.23.1 builds and runs perfectly well on x86-32. I haven't
tried 2.6.23, but I see no reason why it should act any differently.)

-- 
`Some people don't think performance issues are "real bugs", and I think 
such people shouldn't be allowed to program.' --- Linus Torvalds
