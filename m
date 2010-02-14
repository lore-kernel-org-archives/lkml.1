Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab0BNLy1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 06:54:27 -0500
Received: from tossu.ebaana.net ([62.121.33.10]:4120 "EHLO tossu.ebaana.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097Ab0BNLy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 06:54:26 -0500
From: Lasse Collin <lasse.collin@tukaani.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [kernel.org users] XZ Migration discussion
Date: Sun, 14 Feb 2010 11:56:21 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.30-ARCH; KDE/4.3.1; i686; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Willy Tarreau <w@1wt.eu>,
       Jean Delvare <khali@linux-fr.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>, mirrors@kernel.org,
       users@kernel.org, "FTPAdmin Kernel.org" <ftpadmin@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <4B744E13.8040004@kernel.org> <4B767989.1010200@s5r6.in-berlin.de> <4B767D34.2080909@s5r6.in-berlin.de>
In-Reply-To: <4B767D34.2080909@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002141156.21576.lasse.collin@tukaani.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-02-13 Stefan Richter wrote:
> PS:  It boils down to CPU time requirements.  For small memory
> systems, there is the XZ Embedded decompressor.

XZ Embedded saves only code size. If the file was compressed with 
settings that make the decompressor require e.g. 65 MiB RAM (xz -9), 
using XZ Embedded won't help you.

XZ Embedded is also very limited. It cannot decompress all .xz files. It 
should still be quite useful, since on some architectures it can 
compress the kernel image better than the current LZMA support in the 
kernel, and the API should be nice to use e.g. by Squashfs.

-- 
Lasse Collin  |  IRC: Larhzu @ IRCnet & Freenode
