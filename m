Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbZJNL6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbZJNL6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 07:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbZJNL6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 07:58:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37144 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754302AbZJNL6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 07:58:17 -0400
Date: Wed, 14 Oct 2009 12:58:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Fulghum <paulkf@microgate.com>, Boyan <btanastasov@yahoo.co.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       "OGAWA Hirofumi \"" <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.PaB.Ozl0KB@chimera>
	<C4F8B19E-F4B4-47F3-AE5B-4581C8E3F3AE@gmail.com>
	<87ljjgfcbu.fsf@spindle.srvr.nix>
	<alpine.LFD.2.01.0910121703390.3438@localhost.localdomain>
	<alpine.LFD.2.01.0910122004200.3438@localhost.localdomain>
	<4AD3F769.5080405@gmail.com>
	<alpine.LNX.2.01.0910130405200.9297@dyndns.pervalidus.net>
	<4AD437F9.9020708@yahoo.co.uk>
	<alpine.LFD.2.01.0910130745550.3438@localhost.localdomain>
	<4AD4DE4C.4010402@yahoo.co.uk>
	<alpine.LFD.2.01.0910131317360.26777@localhost.localdomain>
	<4AD4F548.2030506@microgate.com>
	<alpine.LFD.2.01.0910131514100.3404@localhost.localdomain>
	<1255478932.19056.24.camel@localhost.localdomain>
	<4AD51D6B.7010509@microgate.com>
	<alpine.LFD.2.01.0910131744590.3404@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop a moment. The code wasn't designed to permit two paralle calls of
flush_to_ldisc to the same tty. That was always forbidden when that code
was designed.

It got broken because someone changed that rule recently (and because
the locking was too clever)

Alan
