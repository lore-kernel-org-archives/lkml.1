Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbYHEMlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbYHEMlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 08:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYHEMk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 08:40:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52165 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752789AbYHEMk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 08:40:57 -0400
Date: Tue, 5 Aug 2008 13:22:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Cliffe <cliffe@ii.net>, Casey Schaufler <casey@schaufler-ca.com>,
       Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC 0/5] [TALPA] Intro to a linux interface for on access
 scanning
Message-ID: <20080805132251.300924c0@lxorguk.ukuu.org.uk>
In-Reply-To: <20080805034611.GA11399@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<4897BFB4.9090309@schaufler-ca.com>
	<4897C2A7.7020601@ii.net>
	<20080805034611.GA11399@kroah.com>
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

> Remember, the big issue here isn't the kernel "hooks", but the fact that
> a lot of people are yet to be convinced that something like this needs
> to be within the kernel itself.

Mostly the same people who said that about LSM I note 8)

> Perhaps we should dig up the proposals for the filesystem-notify type
> patches, something like that might be all the majority of the virus
> people need, as they want to just scan things for Windows viruses, not
> Linux ones, and to do so "lazily" might be sufficient.

The key difference between a lazy scan and an active intervention is tiny
- the ability to block in the security decision to open a file.

Once you have that bit you have the ability to hand the file handle up to
a daemon to chew on and return a status. The same co-incidentally gives
you the hooks for doing various kinds of HSM as you can block an open
while you retrieve the archived content from wherever it was warehoused.

Alan
