Return-Path: <linux-kernel-owner+w=401wt.eu-S933882AbZJMKeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882AbZJMKeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933460AbZJMKd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:33:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36239 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933487AbZJMKd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:33:57 -0400
Date: Tue, 13 Oct 2009 11:34:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Nix <nix@esperi.org.uk>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Boyan <btanastasov@yahoo.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       " =?ISO-8859-14?B?RnLpZOlyaWM=?= L. W. Meunier" <fredlwm@gmail.com>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091013113434.22f4fcde@lxorguk.ukuu.org.uk>
In-Reply-To: <4AD3F769.5080405@gmail.com>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
	<87ljjgfcbu.fsf@spindle.srvr.nix>
	<alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
	<alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
	<4AD3F769.5080405@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I can throw your patch in over here for the heck of it.
> If there's somebody who's really hitting this bug
> then the results would be better  if this is the area that causing
> this bug.(from here the only issue I'm seeing is spinning
> history commands in the terminal  from time to time,
> nothing of any unusable keys like others are reporting).

That sounds more like a lost key-up event somewhere higher up the stack.
USB keyboard ? and does it stop if you take the key in question. Also does
it stop if you touch the mouse wheel (assuming you've got mousewheel
bound to shell history somewhere ?)

Alan
