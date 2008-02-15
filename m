Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbYBONZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbYBONZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYBONZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:25:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbYBONZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:25:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <47B490A8.3050500@gmail.com>
References: <47B490A8.3050500@gmail.com>
To: Jan Dittmer <jan.dittmer@gmail.com>
Cc: dhowells@redhat.com, linux-am33-list@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-am33-list] Cross-Compiling mn10300: Assembler messages: junk at end of line: 0
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 15 Feb 2008 13:25:24 +0000
Message-ID: <22098.1203081924@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Dittmer <jan.dittmer@gmail.com> wrote:

> + make ARCH=mn10300 HOSTCC=gcc-4.0 CROSS_COMPILE=mn10300-elf- 
> CROSS32_COMPILE= O=../2.6.25-rc1-mn10300/

Hmmm...  There seems to be some confusion somewhere, probably because the
documentation there doesn't say which compiler you should use for what.  Can
you try this toolchain instead:

	i686-pc-linux-gnulibc2.3-x-am33_2.0-linux-gnu.tar.bz2

rather than the:

	i686-pc-linux-gnulibc2.3-x-mn10300-elf.tar.bz2

in the location:

	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/am33-04r2-5/tools/

Note that the MN10300 arch needs some patches to get it to compile due to some
changes that Linus merged that weren't in the -mm tree.

David
