Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZAELUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZAELUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbZAELUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:20:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43206 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752776AbZAELUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:20:05 -0500
Date: Mon, 5 Jan 2009 11:19:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rob Landley <rob@landley.net>
Cc: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@suse.cz>,
       Sitsofe Wheeler <sitsofe@yahoo.com>, Duane Griffin <duaneg@dghda.com>,
       Valdis.Kletnieks@vt.edu,
       Martin =?UTF-8?B?TU9LUkVKxaA=?= <mmokrejs@ribosome.natur.cuni.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090105111913.47a8d1a5@lxorguk.ukuu.org.uk>
In-Reply-To: <200901042149.27655.rob@landley.net>
References: <fa.pmCH9X+XujDl6RH6/TpkNtsTnbk@ifi.uio.no>
	<20090104224052.GE1913@elf.ucw.cz>
	<20090104233052.GG22958@mit.edu>
	<200901042149.27655.rob@landley.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That would be true if the disk hardware wasn't doing a gazillion retries to 
> read a bad sector internally (taking 5 seconds to come back and report 
> failure), and then the darn scsi layer added another gazillion retries on top 
> of that, and the two multiply together to make it so slow that that when you 
> leave the thing copying the disk overnight it's STILL not done 24 hours later.  
> Going in and cherry picking individual files looks kind of appealing in that 
> situation.

You could of course just learn to use the functions the kernel provides.
If you want to recover disk blocks without retrying you can do that via
SG_IO. If you want to adjust the timeout and retry levels you can do that
too via sysfs.

Alan
