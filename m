Return-Path: <linux-kernel-owner+w=401wt.eu-S1759531AbZAMNse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbZAMNse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbZAMNsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:48:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53203 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757759AbZAMNsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:48:23 -0500
Date: Tue, 13 Jan 2009 13:47:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, David Rientjes <rientjes@google.com>,
       Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090113134720.5774b442@lxorguk.ukuu.org.uk>
In-Reply-To: <20090113131937.GB17664@mit.edu>
References: <20090112161931.6203f96e@lxorguk.ukuu.org.uk>
	<20090112162938.GA22647@ioremap.net>
	<496BCB7A.2010804@tmr.com>
	<20090112231728.GA23803@ioremap.net>
	<alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com>
	<20090113085244.GA13796@ioremap.net>
	<alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com>
	<20090113115408.GA22289@ioremap.net>
	<20090113121510.68a55fe9@lxorguk.ukuu.org.uk>
	<20090113122904.GC25011@ioremap.net>
	<20090113131937.GB17664@mit.edu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (i.e., shell support, PAM support in /etc/securitylimits.conf); all
> that would need to be done is to teach a few userspace
> programs/libraries about the new resource limit.

You don't even need that - just define the behaviour of oom_adj to
inherit.

Of course thats still often totally the wrong behaviour as you'll find out
when a key system service is started up by a client that wants to use it
that was run by some low privilege untrusted process with tight resource
limits.

For desktop Jim Gettys proposed a very simple and quite elegant use of
this sort of thing which was to let the window manager do some of the
work according to what hadn't been used for ages.
