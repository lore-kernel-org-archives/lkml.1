Return-Path: <linux-kernel-owner+w=401wt.eu-S933924AbZJMP53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbZJMP53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933914AbZJMP52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:57:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56176 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933907AbZJMP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:57:27 -0400
Date: Tue, 13 Oct 2009 17:56:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Nix <nix@esperi.org.uk>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>, Ed Tomlinson <edt@aei.ca>,
       =?iso-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= Meunier <fredlwm@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091013155647.GB2127@basil.fritz.box>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera> <L6tb-VyKHZK.A.PaB.Ozl0KB@chimera> <C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com> <87ljjgfcbu.fsf@spindle.srvr.nix> <20091013003841.6c2988d0@lxorguk.ukuu.org.uk> <20091012234641.GF8345@core.coreip.homeip.net> <20091013120046.5efb3365@lxorguk.ukuu.org.uk> <alpine.LRH.2.00.0910131645290.12171@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0910131645290.12171@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This has been reported by Andi Kleen some time ago [1] [2]. He seems to 
> have had clear idea between which kernel versions this started happening 
> and seemed to be able to reproduce it very reliably (which wasn't the case 
> on my side), but I don't think he bisected it down to single commit yet.
> 
> Andi?

I've never tried to bisect it, but I think it was introduced between
.29->.30. Or at least I had never noticed the problem before upgrading
to some .30rc*

My symptoms were slightly different from Alan though, for me the actual
console switch leaked. I can't remember seeing keys before the switch
leaking too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
