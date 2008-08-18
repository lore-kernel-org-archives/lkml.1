Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbYHRRoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbYHRRoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 13:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYHRRoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 13:44:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34782 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751586AbYHRRoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 13:44:12 -0400
Date: Mon, 18 Aug 2008 18:25:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       david@lang.hm, Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro	to
 a linux interface for on access scanning
Message-ID: <20080818182556.13ced58f@lxorguk.ukuu.org.uk>
In-Reply-To: <1219080504.15566.65.camel@localhost.localdomain>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
	<1219076143.15566.39.camel@localhost.localdomain>
	<20080818171500.78590801@lxorguk.ukuu.org.uk>
	<1219080504.15566.65.camel@localhost.localdomain>
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

> I think I'm going to stick with my special file in securityfs since it
> makes it some simple to install the fd in the scanning process (as
> opposed to netlink where I don't even know how it would be possible...)

AF_UNIX passes file handles just fine. I'm not sure netlink will help you
here anyway - isn't it lossy under load ?

Also securityfs is more special purpose magic here - what does it have to
do with a general purpose notifier API ? I'd actually generalise the
notifier properly and go for a syscall.

Alan
