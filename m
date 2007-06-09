Return-Path: <linux-kernel-owner+w=401wt.eu-S1761940AbXFIWNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940AbXFIWNK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 18:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760632AbXFIWM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 18:12:57 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1166 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbXFIWM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 18:12:56 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 9 Jun 2007 15:12:54 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Matt Mackall <mpm@selenic.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070609214120.GD11166@waste.org>
Message-ID: <Pine.LNX.4.64.0706091508480.14445@alien.or.mcafeemobile.com>
References: <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk>
 <466AD4BA.80407@redhat.com> <20070609165454.GE4095@ftp.linux.org.uk>
 <466ADEAB.7080202@redhat.com> <20070609172429.GF4095@ftp.linux.org.uk>
 <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com> <20070609200645.GG4095@ftp.linux.org.uk>
 <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706091326050.14445@alien.or.mcafeemobile.com>
 <20070609214120.GD11166@waste.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Jun 2007, Matt Mackall wrote:

> On Sat, Jun 09, 2007 at 01:31:56PM -0700, Davide Libenzi wrote:
> > On Sat, 9 Jun 2007, Linus Torvalds wrote:
> > 
> > > So I think both the FD_CLOEXEC _and_ the "private fd space" are real 
> > > issues. I don't agree with the "random fd" approach. I'd much rather have 
> > > a non-random setup for the nonlinear ones (it just shouldn't be linear).
> > 
> > That is fine for me. So what about the randomness?
> > 
> > A) Don't do it at all
> > 
> > B) Let userspace select it in some way globally
> > 
> > C) Let userspace select it per-fd (this won't be an O(1) anymore though)
> 
> It should be handled the same way that VMA layout randomness is
> handled. There are multiple knobs including ELF markers and /proc
> bits.

You mean a global bit controlled by /proc, eventually overridden by an ELF 
flag? An maybe a prctl() to give sw configurability?



- Davide


