Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbXJ3KUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbXJ3KUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 06:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbXJ3KUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 06:20:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbXJ3KUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 06:20:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18215.1394.294830.944162@zebedee.pink>
Date: Tue, 30 Oct 2007 10:20:34 +0000
From: Andrew Haley <aph@redhat.com>
To: "David Schwartz" <davids@webmaster.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Is gcc thread-unsafe?
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCELIHMAC.davids@webmaster.com>
References: <18210.2314.57767.962503@zebedee.pink>
	<MDEHLPKNGKAHNMBLJOLKCELIHMAC.davids@webmaster.com>
X-Mailer: VM 7.19 under Emacs 22.0.93.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz writes:
 > 
 > > Well, yeah.  I know what you mean.  However, at this moment, some
 > > gcc developers are trying really hard not to be total d*ckheads
 > > about this issue, but get gcc fixed.  Give us a chance.
 > 
 > Can we get some kind of consensus that 'optimizations' that add
 > writes to any object that the programmer might have taken the
 > address of are invalid on any platform that supports memory
 > protection?

That's what the proposed standard language says, kinda-sorta.  There's
an informal description at
http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2338.html.

Anyway, we have fixed this bug and are committing it to all open gcc
branches.  Credit to Ian Taylor for writing the patch.

Andrew.

-- 
Red Hat UK Ltd, Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, UK
Registered in England and Wales No. 3798903
