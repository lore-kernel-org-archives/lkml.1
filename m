Return-Path: <linux-kernel-owner+w=401wt.eu-S1760683AbXGJX1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760683AbXGJX1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXGJX1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:27:47 -0400
Received: from ozlabs.org ([203.10.76.45]:36077 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbXGJX1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:27:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18068.5612.100418.782729@cargo.ozlabs.ibm.com>
Date: Wed, 11 Jul 2007 09:27:40 +1000
From: Paul Mackerras <paulus@samba.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Amit Arora <aarora@in.ibm.com>,
       Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, "Luck, Tony" <tony.luck@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mark Fasheh <mark.fasheh@oracle.com>, linux-arch@vger.kernel.org
Subject: Re: fallocate-implementation-on-i86-x86_64-and-powerpc.patch
In-Reply-To: <4693C580.2000506@garzik.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710115251.GG2343@thunk.org>
	<20070710101558.cea7aab1.akpm@linux-foundation.org>
	<4693C580.2000506@garzik.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik writes:

> Andrew Morton wrote:
> > So I dropped everything.  Let's start again from scratch.  I'd suggest that
> > for now we go with just an i386/x86_64 implementation, let the arch
> > maintainers wire things up when that has settled down.
> 
> 
> It's my observation that that plan usually works the best.  Arch 

... except when the initial implementer picks an argument order which
doesn't work on some archs, as happened with sys_sync_file_range.
That is also the case with fallocate IIRC.

We did come up with an order that worked for everybody, but that
discussion seemed to get totally ignored by the ext4 developers.

Paul.
