Return-Path: <linux-kernel-owner+w=401wt.eu-S1030342AbXDPLTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030342AbXDPLTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030357AbXDPLTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:19:54 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:58654 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030342AbXDPLTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:19:53 -0400
Date: Mon, 16 Apr 2007 07:19:19 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Mike Snitzer <snitzer@gmail.com>,
       Neil Brown <neilb@suse.de>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
In-Reply-To: <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl>
Message-ID: <alpine.DEB.0.83.0704160711010.16021@sigma.j-a-k-j.com>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> 
 <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com>
 <Pine.LNX.4.61.0704142251380.15892@yvahk01.tjqt.qr>
 <Pine.BSO.4.63.0704161120070.11088@rudy.mif.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> FUSE implemtation uses too many context switches on each I/O so on the same
> hardware it will never will be so fast as on Linux, BSD and MOX (yes ZFS is
> now avalaible on all this OSes .. and few people says Windows implemtation is
> very close). Current FUSE implemntation can't be comparable in aspects of
> speed and probably never will be on using threads (very simmilar case to ALSA
> and mixing in user space .. in both cases it is broken by design). Also ZFS on
> Solaris uses few other system abilities for example it interract with PSH.
> 
> So FUSE ZFS is IMO only kind of academic demo implemtation only but never will
> be usefull/ready for production (plain waste of time). If Linux licensing will
> not be relaxed probaly we can forget about ZFS on Linux (licensing problems in
> this case are obly on Linux side .. <ironically>in this case ZFS licensing is
> more oppened than Linux licensing </ironically>).
> 
> kloczek
> PS. IIRC implemting ZFS on FUSE was some kind of workaround for licensing
> issue but FUSE fill uses vfs layer and probaly still thinking about
> licensing is actual.

I'm just a lowly proto-hacker trying to get into kernel development, but 
even I know a few things, and I'm getting very tired of hearing FUSE 
slammed as stupid and the Linux licencing policy as foolish. I can sum 
things up in two short passages.

FUSE is intended for end-users, not critical server applications. 
End-users have plenty of processor to spare at lower-than-ever prices. So 
you have a simple and flexible end-user API that lets you do anything with 
anything in any way you want, all the time, without needing to (or even 
needing to be able to) alter your kernel. Win.

Linux licencing basically says, "If you want in on this good thing, you 
have to play by the rules. That means no cheating, no scamming, no 
profiting at the expense of others, and no getting on a high horse and 
proclaiming to the rest of the world that you are in control of their 
destinies. Play nice, kiddies." If you want to do something, you do it 
open and you do it Free, and if you don't want to, well...write your own 
kernel!

There is a wonderful quotation on the GNU site comparing agencies like 
Microsoft to crack dealers: They appear more open in theory in order to 
get people hooked, then trigger the beartrap around your foot. Linux has 
rules--hard, fast, and immutable--and they protect everybody from their 
own stupidities. Open-community development takes a whole lot longer, but 
you don't have to sell your soul to do it.
