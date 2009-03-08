Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbZCHBh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbZCHBh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 20:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbZCHBhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 20:37:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:57603 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbZCHBhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 20:37:46 -0500
Date: Sat, 7 Mar 2009 17:38:19 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Paul Bolle <pebolle@tiscali.nl>, Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: [PATCH 1/2] gigaset: return -ENOSYS for unimplemented functions
Message-ID: <20090307173819.36d352c8@infradead.org>
In-Reply-To: <49B3176A.7000004@imap.cc>
References: <20090307-patch-00.tilman@imap.cc>
	<20090307-patch-01.tilman@imap.cc>
	<20090307142609.2995bb3d@infradead.org>
	<49B30FC4.5040305@imap.cc>
	<20090307163522.1165494b@infradead.org>
	<49B3176A.7000004@imap.cc>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 08 Mar 2009 01:55:06 +0100
Tilman Schmidt <tilman@imap.cc> wrote:

> Am 08.03.2009 01:35 schrieb Arjan van de Ven:
> > On Sun, 08 Mar 2009 01:22:28 +0100
> > Tilman Schmidt <tilman@imap.cc> wrote:
> > 
> >> Am 07.03.2009 23:26 schrieb Arjan van de Ven:
> [...]
> >>> ENODEV is what would be more appropriate.
> >> Not at all. ENODEV means "no such device", which would be quite
> >> wrong. The device does exist and is in all probability working
> >> perfectly fine. It just doesn't implement that particular ioctl.
> > 
> > then -ENOTTY is the right answer
> 
> Interesting, though slightly surprising proposition.
> "Not a typewriter" is certainly correct. :-)
> 
> "Not a tty device", however, which I take is the customary
> interpretation, much less clearly so. The device most certainly
> is a tty device. It just happens to know a few additional ioctl
> commands which may or may not be implemented, depending on the
> kernel config.
> 
> Not to question your authority, but I would really like a second
> opinion on that issue before I adopt your proposition, simply to
> minimize the risk of getting another objection from someone else
> who feels that ENOTTY is inappropriate in that situation.


from the ioctl manpage:

ERRORS
	[snip]

       ENOTTY The specified request does not apply to the kind of
       object that the descriptor d references.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
