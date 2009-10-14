Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbZJNVjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbZJNVjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbZJNVjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:39:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45472 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755327AbZJNVjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:39:18 -0400
Date: Wed, 14 Oct 2009 22:39:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boyan <btanastasov@yahoo.co.uk>, Oleg Nesterov <oleg@redhat.com>,
       Paul Fulghum <paulkf@microgate.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       hirofumi@mail.parknet.co.jp
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
Message-ID: <20091014223945.64eaffcf@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0910141356400.6146@localhost.localdomain>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
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
	<20091014125846.1a3c8d40@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0910140804180.6146@localhost.localdomain>
	<alpine.LFD.2.01.0910140925440.6146@localhost.localdomain>
	<4AD62DAD.9010604@yahoo.co.uk>
	<alpine.LFD.2.01.0910141356400.6146@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009 14:02:10 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 14 Oct 2009, Boyan wrote:
> > 
> > Works for me. I couldn't reproduce the problem with only this patch on
> > top of  2.6.31.4.
> 
> So just to verify: both the flush_to_ldisc() patch _and_ the 
> "flush_delayed_work()" one fixed the problem for you? And you tested them 
> independently? And you said you could reliably trigger it before?
> 
> Ok, that makes me happy, because it implies that this really is the root 
> cause, with two different approaches to fixing the same problem both 
> working independently of each other.

It also seems to fix the "letters leaking across a console switch". Can't
be sure as its not trivial to reproduce but it seems to have gone too.
