Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbXFDWkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbXFDWkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbXFDWkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:40:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55986 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753540AbXFDWkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:40:02 -0400
Date: Mon, 4 Jun 2007 23:44:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeff Dike <jdike@addtoit.com>, Zach Brown <zach.brown@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Syslets, signals, and security
Message-ID: <20070604234453.06162eb9@the-village.bc.nu>
In-Reply-To: <p73vee3a14x.fsf@bingen.suse.de>
References: <20070604163145.GA7144@c2.user-mode-linux.org>
	<20070604174542.GD29201@mami.zabbo.net>
	<20070604191349.GA8903@c2.user-mode-linux.org>
	<p73vee3a14x.fsf@bingen.suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem is that you would need to reference count/lock them in every
> syscall or ioctl or similar. Otherwise another thread
> could change them in the middle of a syscall which wouldn't be
> good. Doing this full reference counting would be probably somewhat
> expensive with more locked cycles and also a lot of work to implement.
> You would need to audit large parts of the source tree.

It also mucks up the rather more powerful existing behaviour unless we
make the changing optional in which case it gets *really ugly*

> I don't think it's a good idea.

Ditto (and glibc handles it for userspace posix APIs)
