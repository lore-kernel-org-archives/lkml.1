Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbXGEBmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbXGEBmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 21:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbXGEBmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 21:42:21 -0400
Received: from canuck.infradead.org ([209.217.80.40]:48810 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbXGEBmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 21:42:20 -0400
Subject: Re: [1/2] 2.6.22-rc7: known regressions
From: David Woodhouse <dwmw2@infradead.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, marcel@holtmann.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>
In-Reply-To: <468A7D14.1050505@googlemail.com>
References: <468A7D14.1050505@googlemail.com>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 21:42:51 -0400
Message-Id: <1183599771.2740.19.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 18:45 +0200, Michal Piotrowski wrote:
> Hi all,
> 
> Here is a list of some known regressions in 2.6.22-rc7.

Oh, and here's another one for you. My Bluetooth mouse just stopped
working and hidd is deadlocked...

hidd          D 1FE27798  5940  1695      1 (NOTLB)
Call Trace:
[ef3ddb70] [00000004] 0x4 (unreliable)
[ef3ddc30] [c0008e7c] __switch_to+0x50/0x68
[ef3ddc50] [c02d5998] schedule+0x3cc/0x480
[ef3ddc80] [c0137a20] rwsem_down_failed_common+0x1c4/0x1f4
[ef3ddcb0] [c02d7454] rwsem_down_write_failed+0x28/0x40
[ef3ddce0] [c004ff60] down_write+0x50/0x64
[ef3ddd00] [f27f2068] hidp_add_connection+0x168/0x75c [hidp]
[ef3ddd40] [f27f2e44] hidp_sock_ioctl+0x140/0x414 [hidp]
[ef3ddeb0] [c024da6c] sock_ioctl+0x248/0x284
[ef3dded0] [c00ab02c] do_ioctl+0x38/0x84
[ef3ddee0] [c00ab448] vfs_ioctl+0x3d0/0x404
[ef3ddf10] [c00ab4e4] sys_ioctl+0x68/0x98

-- 
dwmw2

