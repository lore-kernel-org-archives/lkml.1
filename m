Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbYHEM50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbYHEM50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759480AbYHEMus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:50:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34831 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758064AbYHEMus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:50:48 -0400
Date: Tue, 5 Aug 2008 13:32:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kyle Moffett" <kyle@moffetthome.net>
Cc: "Christoph Hellwig" <hch@infradead.org>, "Eric Paris" <eparis@redhat.com>,
       "Greg KH" <greg@kroah.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for
 on access scanning
Message-ID: <20080805133247.70f1f28b@lxorguk.ukuu.org.uk>
In-Reply-To: <f73f7ab80808042249r4a29510foedbbae595c947028@mail.gmail.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<20080805002618.GA18215@infradead.org>
	<1217897224.27684.66.camel@localhost.localdomain>
	<20080805005415.GA10108@infradead.org>
	<f73f7ab80808042249r4a29510foedbbae595c947028@mail.gmail.com>
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

> Much better solution:

And one which was found lacking about 1950...

> Problem solved.  Untrusted and possibly-compromised files can't be
> executed, or even if they could be they can't do anything

Two things
- Scripts
- Attacks based on compromising a live binary

You can use SELinux to control what is executed and it is a very
effective management control technique. However it doesn't control
javascript in web pages, exploits that popen perl and chat to it and so
on...
