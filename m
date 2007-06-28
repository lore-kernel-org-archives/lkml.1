Return-Path: <linux-kernel-owner+w=401wt.eu-S1764521AbXF1HWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764521AbXF1HWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 03:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbXF1HVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 03:21:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXF1HVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 03:21:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200706272350.04975.m.kozlowski@tuxland.pl>
References: <200706272350.04975.m.kozlowski@tuxland.pl> <200706271030.l5RAUgKE015163@imap1.linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: akpm@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       dhowells@redhat.com
Subject: Re: [PATCH] mtd: add module license to mtdbdi
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Thu, 28 Jun 2007 08:21:08 +0100
Message-ID: <1224.1183015268@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> 	This seems to be a known issue [1] about Photron PNC-2000 module called
> pnc2000. To reproduce this just 'modprobe pnc2000'. The patch attached at least
> makes the kernel to be not tainted when mtdbdi gets loaded.

This is the wrong solution.  This file should not be its own module, but
should rather be linked with mtdcore.

There was a patch for this, but I don't know what happened to it.

David
