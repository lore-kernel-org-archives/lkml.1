Return-Path: <linux-kernel-owner+w=401wt.eu-S1762123AbXKPRQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762123AbXKPRQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 12:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752258AbXKPRP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 12:15:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbXKPRP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 12:15:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071116163645.GA7855@fluff.org.uk>
References: <20071116163645.GA7855@fluff.org.uk> <20071116134105.3823.66507.stgit@warthog.procyon.org.uk> <20071116134100.3823.12894.stgit@warthog.procyon.org.uk> <9004.1195229483@redhat.com>
To: Ben Dooks <ben@fluff.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 2/2] MN10300: Fix MTD JEDEC probe so that the ASB2303 bootprom can be detected
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 16 Nov 2007 17:15:20 +0000
Message-ID: <9555.1195233320@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks <ben@fluff.org> wrote:

> Often write protect on flash chips is a seperate pin that disables
> the cell writing circuitry, not the nWE pin.

That may be true, but the board documentation in this particular case doesn't
list any way of write-enabling the flash.  I have another, different board
based on the same CPU that does have a write enable for its bootprom.

David
