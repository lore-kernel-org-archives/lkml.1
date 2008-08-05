Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbYHELmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbYHELmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbYHELm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:42:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60472 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759533AbYHELm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:42:28 -0400
Date: Tue, 5 Aug 2008 12:25:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for
 on access scanning
Message-ID: <20080805122503.73ea5416@lxorguk.ukuu.org.uk>
In-Reply-To: <20080805005132.GA3661@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<1217896374.27684.53.camel@localhost.localdomain>
	<20080805005132.GA3661@kroah.com>
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

> Again, do it all in userspace (caching, and scanning).  I still really
> don't see the need to do this in the kernel becides it being "the way
> people have always done it."

We don't have notifiers for file segment changes that are scalable that
far. We don't have mechanisms for delaying an open for a scan.

There are various bits of this you can't just do in user space. This
doesn't just hurt virus scanners btw its also bad news for indexing disk
content.
