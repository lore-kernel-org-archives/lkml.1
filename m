Return-Path: <linux-kernel-owner+w=401wt.eu-S1031055AbXEAS0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031055AbXEAS0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030972AbXEAS0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:26:14 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38467 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030968AbXEAS0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:26:11 -0400
Date: Tue, 1 May 2007 14:21:56 -0400
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 0/6] cmpxchg cleanups and UML fixes
Message-ID: <20070501182156.GA8373@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This set is a combination of cmpxchg cleanups and UML fixes.

Patches 1 - 3 are the cmpxchg stuff -
	Remove tas() from all arches - I can't find any users.
	Move the i386 cmpxchg to asm-i386/cmpxchg.h
	Move the x86_64 cmpxchg to asm-x86_64/cmpxchg.h

Patches 4 - 6 fix things discovered while playing with pcap interfaces -
	Have the free wrapper detect malloced buffers and call libc free
	Fix the device initialization failure path and other small cleanups
	Allow pcap devices to be assigned MACs on the command line

This is all 2.6.22 material.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
