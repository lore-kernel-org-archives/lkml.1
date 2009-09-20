Return-Path: <linux-kernel-owner+w=401wt.eu-S1754953AbZITRcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbZITRcm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbZITRcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:32:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:49609 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbZITRck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:32:40 -0400
Date: Sun, 20 Sep 2009 19:32:47 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone VPA-II"
 ?
Message-ID: <20090920193247.1d0e49cd@infradead.org>
In-Reply-To: <4AB65D83.1080506@imap.cc>
References: <4AB630AD.90207@imap.cc>
	<20090920150549.GC11621@kroah.com>
	<4AB6581F.5040908@imap.cc>
	<20090920183744.395fc407@infradead.org>
	<4AB65D83.1080506@imap.cc>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009 18:51:15 +0200
Tilman Schmidt <tilman@imap.cc> wrote:

> > btw this is what scripts/markup_oops.pl is for... it gives a very
> > nice diagnostic
> 
> Unfortunately that script doesn't work on my machine:
> 
> ts@xenon:~/kernel/linux-2.6.31-work> ./scripts/markup_oops.pl
> < /tmp/mdabug.txt No vmlinux specified,
> assuming /lib/modules/2.6.31-vanilla/build/vmlinux Can't locate
> object method "from_hex" via package "Math::BigInt"
> at ./scripts/markup_oops.pl line 176, <STDIN> line 98.
> 
> And as it's openSUSE based I can't simply update my Perl packages
> from CPAN. But I can live with the gdb method.

hmm Matthew added that....
should we undo that change??


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
