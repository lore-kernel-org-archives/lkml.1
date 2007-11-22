Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbXKVT6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbXKVT6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 14:58:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbXKVT6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 14:58:43 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34764 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752292AbXKVT6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 14:58:42 -0500
Date: Thu, 22 Nov 2007 19:56:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Why is FIBMAP ioctl root only?
Message-ID: <20071122195620.79c6ecf1@the-village.bc.nu>
In-Reply-To: <20071122102951.24e4e781@laptopd505.fenrus.org>
References: <20071122181714.GB6299@atrey.karlin.mff.cuni.cz>
	<20071122102951.24e4e781@laptopd505.fenrus.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> probably principle of least privilege; the location on physical media
> for a file is clearly something internal to the OS, and non-trusted
> users normally don't have any business knowing that. 

FIBMAP isn't correctly locked against misuse, and that requires FIBMAP is
safe against truncate and relocation. There was thread on l/k about this
a month ago or so.

Its also the wrong API (32bit, no notion of extents, compression etc)
