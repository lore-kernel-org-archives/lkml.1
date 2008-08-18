Return-Path: <linux-kernel-owner+w=401wt.eu-S1764050AbYHRTOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764050AbYHRTOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757992AbYHRTJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:09:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50918 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763386AbYHRTJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:09:27 -0400
Date: Mon, 18 Aug 2008 19:51:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: davecb@sun.com, david@lang.hm, Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA]	Intro	to
 a linux interface for on access scanning
Message-ID: <20080818195126.7192e34e@lxorguk.ukuu.org.uk>
In-Reply-To: <1219084246.15566.86.camel@localhost.localdomain>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
	<1219076143.15566.39.camel@localhost.localdomain>
	<20080818171500.78590801@lxorguk.ukuu.org.uk>
	<1219080504.15566.65.camel@localhost.localdomain>
	<20080818182556.13ced58f@lxorguk.ukuu.org.uk>
	<1219082097.15566.82.camel@localhost.localdomain>
	<1219084246.15566.86.camel@localhost.localdomain>
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

> Also not knowing much about sending FD's over AF_UNIX sockets, do they
> share the same seek offsets or does the new process get a new fd which

They share the seek offset.

> points to the same data?  I wouldn't want to have to count on the
> indexer to not move the offset around on the bittorrent client.  Like I
> said, haven't never used sendmsg to pass a socket I don't know what you
> get on the other end.

man pread(). The posix committee long ago figured out that you needed a
sane way not to get involved with offsets even between processes or in
threaded apps.

Alan
