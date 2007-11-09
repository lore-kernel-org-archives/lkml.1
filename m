Return-Path: <linux-kernel-owner+w=401wt.eu-S1763246AbXKIPIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763246AbXKIPIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761923AbXKIPIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:08:39 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:49967 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762868AbXKIPIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:08:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Hl8+lK6K+hFmRn0xFN241TWk+pEeiMkJIrfbBNDmYaYuepCTphRekkNKabixpvfm/OG3qR8c5rVjgqH1dlXmZZXmL4tcQI1d80Grk5cEAQs+/Jige+oEAX3WPOQrwgXAXIzRCN+/K9t50x684vwhtJICCQoYcjTctaYARFSosis=
Message-ID: <f881070f0711090708u1b77a78dlcdb504a724b22fcf@mail.gmail.com>
Date: Fri, 9 Nov 2007 17:08:37 +0200
From: "Alexandru Damian" <ddalex@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel BUG message while using jffs2
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Sorry for posting here, it seems the best spot; if I need to redirect
this to mtd-utils team, please tell me.

I'm playing around with some jffs2 files. While trying to mount (via
block2mtd, loop) a jffs2 system, a "kernel BUG message" appeared in
dmesg, with these lines:

kernel BUG at mm/slub.c:2204!
invalid opcode: 0000 [#1]
SMP

Call trace is

Call Trace:
 [<c0477358>] __kmalloc+0xd/0x64
 [<f950d626>] jffs2_scan_medium+0x2a5/0x131a [jffs2]
 [<c046137d>] __alloc_pages+0x68/0x2a0
 [<f9516f4b>] jffs2_sum_init+0x50/0x9d [jffs2]


If someone is interested in digging deeper in this, please contact me
directly by email (I'm not subscribed to the list) for more
information

Cheers,
Alex
