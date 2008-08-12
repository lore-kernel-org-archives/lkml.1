Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYHLHtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYHLHtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 03:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYHLHtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 03:49:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39455 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751535AbYHLHtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 03:49:15 -0400
Date: Tue, 12 Aug 2008 08:32:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: daw-news@cs.berkeley.edu (David Wagner)
Cc: daw@cs.berkeley.edu, linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
Message-ID: <20080812083204.53602192@lxorguk.ukuu.org.uk>
In-Reply-To: <g7qdbj$6m0$2@taverner.cs.berkeley.edu>
References: <20080806105008.GF6477@cs181140183.pp.htv.fi>
	<20080811065608.44687f65@infradead.org>
	<48A0649B.4010706@sun.com>
	<2629CC4E1D22A64593B02C43E855530304AE4B80@USILMS12.ca.com>
	<g7qdbj$6m0$2@taverner.cs.berkeley.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> theoretical possibility)?  There are a few obvious ones: files shared
> over a SMB filesystem; attachments sent via email.  What else?  Can
> you give some other examples?

This is the nightclub model and doesn't work viz:

"If I put a big scary man on the door nobody will be able to get knives
and drugs in because we only have one door for the public"

If you have to enumerate the potential attack vectors to make your model
work you already lost. There is one of you and a lot of them. Smart
nightclubs don't do that they circulate looking for evidence. Yes, they
will miss some, yes they will respond late to some, but they will at
least notice there has been a problem.

Now computer security is a bit different because it has some night of the
living dead type properties where the zombies don't just sneak in through
the toilet window but they go around turning security guards into zombies
too but the basic premise is very much the same.

> Are we talking about enterprise networks?  Are we talking about consumers?

What theat model and set of security properties does this change ?
The reasons for poor security may change from 'who cares if we get a
virus, I get an afternoon drinking coffee' to 'not computer skilled' but
the basic problem is very similar.

What are the invariants and what are the probability based things we are
trying to achieve ? What level of interference with existing behaviour is
acceptable ?

The last is important as we SELinux you can achieve much of what is
needed but only at a cost of interfering in normal practice now and then
- eg downloading a shell script versus accidentally downloading a worm is
rather hard for a PC to tell apart so implementing 'written by web
browser, can't be executed' is easy but has side effects

Alan
