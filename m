Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbXIRK1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbXIRK1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbXIRK1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:27:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42126 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754616AbXIRK1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:27:15 -0400
Date: Tue, 18 Sep 2007 11:34:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
Message-ID: <20070918113401.6a8a737f@the-village.bc.nu>
In-Reply-To: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 16:22:07 -0400
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> This patch updates the pci_iomap() kernel-doc to make it clarify the
> case when read*()/write*() can be called over ioread*/iowrite*(). When
> driver writers read this documenation sometimes it is assumed you just
> *need* to use ioread*()/iorwrite*(). We have an exception so lets just
> clarify this is not true for the exception.
> 
>  lib/iomap.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

Reviewed-by: Alan Cox <alan@redhat.com>

Although I would say s/recommended/required/

Alan
