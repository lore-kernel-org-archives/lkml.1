Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbXJ2M3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbXJ2M3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbXJ2M3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:29:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbXJ2M2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:28:40 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux kernel
	[try #2]
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       dhowells@redhat.com
Date: Mon, 29 Oct 2007 12:27:59 +0000
Message-ID: <20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



These patches add the MEI/Panasonic MN10300/AM33 architecture to the Linux
kernel.

The first patch makes it possible to suppress AOUT support in the ELF binfmt.
MN10300 does not support the AOUT binfmt, so the ELF binfmt should not be
permitted to go looking for AOUT libraries to load.

The second patch adds the architecture itself, to be selected by ARCH=mn10300
on the make command line.

The patches can also be downloaded from:

	http://people.redhat.com/~dhowells/mn10300/mn10300-arch.tar.bz2


A suitable toolchain can be downloaded from:

	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/

The latest is currently:

	am33-04r2-5/tools/i686-pc-linux-gnulibc2.3-x-am33_2.0-linux-gnu.tar.bz2

David
