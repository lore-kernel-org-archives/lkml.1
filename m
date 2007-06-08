Return-Path: <linux-kernel-owner+w=401wt.eu-S939289AbXFHT0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939289AbXFHT0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbXFHT0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:26:19 -0400
Received: from [81.2.110.250] ([81.2.110.250]:53209 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750725AbXFHT0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:26:18 -0400
Date: Fri, 8 Jun 2007 20:30:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Davide Libenzi <davidel@xmailserver.org>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070608203007.3c50eb66@the-village.bc.nu>
In-Reply-To: <4669A351.4010403@redhat.com>
References: <466741BD.20106@redhat.com>
	<20070607110432.73be7960@the-village.bc.nu>
	<B8B9EC80-2E36-433E-87EB-5B31FF42FBCF@mac.com>
	<20070607151243.22caab9e.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0706071243090.6445@alien.or.mcafeemobile.com>
	<466864F8.2050903@cosmosbay.com>
	<46686810.6030805@redhat.com>
	<Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
	<466880A4.3090908@redhat.com>
	<Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
	<20070608120746.GD12687@thunk.org>
	<20070608140150.6f31672f@the-village.bc.nu>
	<Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
	<20070608192652.4a291901@the-village.bc.nu>
	<4669A351.4010403@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2007 11:43:29 -0700
Ulrich Drepper <drepper@redhat.com> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Alan Cox wrote:
> > Why does he want an unpredictable algorithm
> 
> To avoid exactly the kind of problem we have now in future: programs
> relying on specific patterns.

Which you seem to think is a bad thing, yet is actually a very good thing
because it means that crashes are repeatable and problems are debuggable
from end user reports.

Trying to randomize filehandles for the general case is not a productive
activity. If you want to debug cases write yourself a glibc wrapper that
does annoying things but don't inflict it on people who actually want to
build working, testable, debuggable systems (ie most of us)

Alan
