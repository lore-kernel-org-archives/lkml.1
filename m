Return-Path: <linux-kernel-owner+w=401wt.eu-S1763690AbXFROHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763690AbXFROHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 10:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762669AbXFROHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 10:07:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:59818 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762614AbXFROHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 10:07:01 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: man-pages-2.57 is released
To: Michael Kerrisk <mtk-manpages@gmx.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Reply-To: 7eggert@gmx.de
Date: Mon, 18 Jun 2007 16:06:36 +0200
References: <8x3Cc-1LD-13@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1I0HsK-0000of-5v@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX183CHhdd+Q2A6JCxIOTRLpoOaCLYDpkqQ3yDxo
 if/0Ix7+5Af+2mTWHytwSsYkwgQcmdrM+a39CX5j1w1PLEJ5G1
 rF00kQ+UYcmBCgInrO3gA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk-manpages@gmx.net> wrote:

> ./man2/ioperm.2
>      FIXME is the following ("Only the first 0x3ff I/O ports can be
>      specified in this manner") still true?  Looking at changes in
>      include/asm-i386/processor.h between 2.4 and 2.6 suggests
>      that the limit is different in 2.6.

You now have the full 64Kb port bitmap (8 KB).


BTW1: linux/arch/i386/kernel/ioport.c still states having 8K of bitmaps to
be excessive (and implicitely and now wrongly as not being done). Since
there should only be few processes requiring iopl, the 8K should not be
excessive. We need a native speaker to change this text, at least not me
right now.

CC Linus, because he admitted fiddeling with this file. (No MAINTAINER found)


BTW2: My (possibly outdated) iopl manpage states that you'll need to be root
change the iopl, but you only need CAP_SYS_RAWIO in order to increase the
iopl.
-- 
Have you ever noticed that the Klingons are all speaking unix?
"Grep ls awk chmod."   "Mknod ksh tar imap."
"Wall fsck yacc!"     (that last is obviously a curse of some sort)
        -- Gandalf  Parker
