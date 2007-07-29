Return-Path: <linux-kernel-owner+w=401wt.eu-S1762878AbXG2NCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762878AbXG2NCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 09:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761986AbXG2NCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 09:02:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48268 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760788AbXG2NCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 09:02:43 -0400
Date: Sun, 29 Jul 2007 14:09:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rik van Riel <riel@redhat.com>
Cc: Al Boldi <a1426z@gawab.com>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: How can we make page replacement smarter
Message-ID: <20070729140936.6cd364a9@the-village.bc.nu>
In-Reply-To: <46ABF184.40803@redhat.com>
References: <200707272243.02336.a1426z@gawab.com>
	<46AAA25E.7040301@redhat.com>
	<200707280717.41250.a1426z@gawab.com>
	<46ABF184.40803@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Files are different.  File content tends to be grouped
> in large related chunks, both logically in the file and
> on disk.  Generally there is a lot more file data on a
> system than what fits in memory.

Binary paging patterns don't always look like that unfortunately although
I suspect we might want to be weighing towards paging out R/O file mapped
pages earlier simply because they are bigger linear chunks
