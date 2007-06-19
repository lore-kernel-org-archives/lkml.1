Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbXFSOcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbXFSOcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbXFSOcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:32:46 -0400
Received: from snowcat.de ([89.31.32.98]:3964 "EHLO snowcat.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbXFSOcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:32:45 -0400
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] Char: istallion, init+locking fixes
Organization: Disorganized
From: Ingo Korb <usenet@mail.snowcat.de>
In-Reply-To: <467788D0.4060802@gmail.com> (Jiri Slaby's message of "Tue, 19
 Jun 2007 09:42:08 +0200")
References: <uir9l9e1j.fsf@dragon.akana.de> <467788D0.4060802@gmail.com>
Date: Tue, 19 Jun 2007 16:32:30 +0200
Message-ID: <uejk89fr5.fsf@dragon.akana.de>
User-Agent: Gnus/5.1002 (Gnus v5.10.2) Emacs/21.3 (windows-nt)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:21:070619:alan@lxorguk.ukuu.org.uk::ic98CAyl+L1uA4ty:0000000000000
	000000000000000000000000BTUn
X-Hashcash: 1:21:070619:linux-kernel@vger.kernel.org::t6qoW0EAduckDyr4:000000000
	0000000000000000000000006p4K
X-Hashcash: 1:21:070619:akpm@linux-foundation.org::B8VH40Lh/X3vQzqf:000000000000
	0000000000000000000000007R/C
X-Hashcash: 1:21:070619:jirislaby@gmail.com::y0TqOIsDMGIYPihv:000000000000000000
	000000000000000000000000TAJd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

>>  	unsigned char __iomem *bits;
>>  	unsigned long flags;
>
> Remove the flags and you will see the bug, you introduced ;).

Oops. I guess I shouldn't try to work on kernel stuff while tired. Fixed
patch follows.

-ik

