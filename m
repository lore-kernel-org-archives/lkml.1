Return-Path: <linux-kernel-owner+w=401wt.eu-S1756790AbYLJVug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbYLJVug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 16:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYLJVu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 16:50:28 -0500
Received: from ozlabs.org ([203.10.76.45]:50426 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbYLJVu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 16:50:27 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18752.14748.408940.386056@cargo.ozlabs.ibm.com>
Date: Thu, 11 Dec 2008 08:50:20 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Howells <dhowells@redhat.com>
Cc: Yuri Tikhonov <yur@emcraft.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>,
       linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
       linuxppc-dev@ozlabs.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Ilya Yanok <yanok@emcraft.com>
Subject: Re: Re[2]: [PATCH] fork_init: fix division by zero
In-Reply-To: <5545.1228914404@redhat.com>
References: <1795455197.20081210132912@emcraft.com>
	<200812092044.40649.yur@emcraft.com>
	<Pine.LNX.4.64.0812100944080.25126@vixen.sonytel.be>
	<503391615.20081210130113@emcraft.com>
	<20081210101745.GG28946@ZenIV.linux.org.uk>
	<5545.1228914404@redhat.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells writes:

> Ummm...  On powerpc, I believe rotate-left would be a division as it does the
> bit-numbering and the bit direction the opposite way to more familiar CPUs
> such as x86.

No.  :)

"Left" and "right" are relative to the way those of us humans in the
Western European cultural tradition write numbers, which is
big-endian.  So rotate-left always moves bits towards the more
significant end of the word.

Paul.
