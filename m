Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYJTS2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYJTS2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbYJTS2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:28:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:60206 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYJTS2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:28:40 -0400
Date: Mon, 20 Oct 2008 11:28:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at arch/x86/mm/ioremap.c:226
Message-ID: <20081020112851.3ea44576@infradead.org>
In-Reply-To: <1224526053.4948.2.camel@dhcppc2>
References: <1224526053.4948.2.camel@dhcppc2>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   16.914566] ck804xrom ck804xrom_init_one(): Unable to register resource 0x00000000ff000000-0x00000000ffffffff - kernel bug?
[   16.914575] resource map sanity check conflict: 0xff000000
0xffffffff 0xff780000 0xffffffff reserved

[   16.914636]  [<c042c02c>] ioremap_nocache+0xd/0xf
[   16.914640]  [<f87e4246>] ? init_ck804xrom+0x246/0x4c7 [ck804xrom]
[   16.914643]  [<f87e4246>] init_ck804xrom+0x246/0x4c7 [ck804xrom]

the init_ck804xrom driver seems to be requesting a bunch of memory with ioremap that crosses several resources...
which is very bad.

Can you sent the /proc/iomem file ?
