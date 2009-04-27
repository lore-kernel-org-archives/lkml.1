Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbZD0XoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbZD0XoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 19:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZD0XoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 19:44:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56555 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbZD0XoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 19:44:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1240864388-26315-4-git-send-email-tabbott@mit.edu>
References: <1240864388-26315-4-git-send-email-tabbott@mit.edu> <1240864388-26315-1-git-send-email-tabbott@mit.edu> <1240864388-26315-2-git-send-email-tabbott@mit.edu> <1240864388-26315-3-git-send-email-tabbott@mit.edu>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: dhowells@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 03/14] mn10300: Use macros for .bss.page_aligned section.
Date: Tue, 28 Apr 2009 00:43:02 +0100
Message-ID: <4678.1240875782@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott <tabbott@MIT.EDU> wrote:

> -	*(.bss.page_aligned)
> +	PAGE_ALIGNED_BSS

/opt/nickc/H-i686-pc-linux-gnulibc2.3/bin/am33_2.0-linux-gnu-ld: cannot find PAGE_ALIGNED_BSS

warthog>grep -r PAGE_ALIGNED_BSS include/linux/
warthog1>grep -r PAGE_ALIGNED_BSS include/asm-generic/
warthog1>grep -r PAGE_ALIGNED_BSS arch/frv/
warthog1>

I take it that wasn't what you meant.

David
