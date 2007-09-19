Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbXISR7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbXISR7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760626AbXISR7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:59:20 -0400
Received: from [81.2.110.250] ([81.2.110.250]:49505 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757035AbXISR7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:59:18 -0400
Date: Wed, 19 Sep 2007 19:06:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, netdev <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: follow-up: discrepancy with POSIX
Message-ID: <20070919190604.342363b4@the-village.bc.nu>
In-Reply-To: <46F1608E.7060908@redhat.com>
References: <46F13E8B.4050309@redhat.com>
	<p73sl5aveqh.fsf@bingen.suse.de>
	<46F15305.2030507@redhat.com>
	<20070919172653.GB18045@one.firstfloor.org>
	<46F1608E.7060908@redhat.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 10:46:54 -0700
Ulrich Drepper <drepper@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Andi Kleen wrote:
> >> But the spec calls for a "null address" to be used and that's in my
> >> understanding something different from using AF_UNSPEC.
> > 
> > memset(&sockaddr, 0, sizeof(sockaddr)) should give you AF_UNSPEC
> 
> But the spec calls for <quote>null address for the protocol</quote>.
> 
> That means the family for the null address is the same as the family of
> the socket.

Which is a valid address in some protocols. If I remember rightly then
appletalk net 0 node 0 port 0 is valid although I'd want to look in the
book to check that - ditto AF_ECONET although I doubt anyone cares too
much 8)

Alan
