Return-Path: <linux-kernel-owner+w=401wt.eu-S1752345AbXCZMAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbXCZMAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 08:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbXCZMAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 08:00:35 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59280 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752314AbXCZMAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 08:00:34 -0400
Date: Mon, 26 Mar 2007 14:03:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       dhowells@redhat.com
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error
 bug
Message-ID: <20070326140350.3c465073@the-village.bc.nu>
In-Reply-To: <6791.1174909459@redhat.com>
References: <Pine.LNX.4.64.0703261427490.12793@sbz-30.cs.Helsinki.FI>
	<20070326024143.a226c9b2.akpm@linux-foundation.org>
	<1174904637.32691.86.camel@roc-desktop>
	<6017.1174908318@redhat.com>
	<6791.1174909459@redhat.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> With NOMMU as it stands, private mappings are private copies of the data, and
> have no impact on the page cache and get no updates from it.  It's as if you
> took a private writable mapping, touched every page and then mprotect()'d it.
> This isn't necessarily ideal, but we're limited by the lack on an MMU.

Given the MMUless kernel has no security model the easiest is probably to
simply not support revoke() of mmap areas on NOMMU (or maybe not to
support revoke at all)

Alan
