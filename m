Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbXEPQqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbXEPQqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbXEPQqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:46:11 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59567 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXEPQqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:46:09 -0400
Date: Wed, 16 May 2007 09:50:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rpurdie@openedhand.com
Subject: Re: 2.6.22-rc1-mm1
Message-Id: <20070516095018.6f0048bc.randy.dunlap@oracle.com>
In-Reply-To: <20070515201914.16944e04.akpm@linux-foundation.org>
References: <20070515201914.16944e04.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 20:19:14 -0700 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc1/2.6.22-rc1-mm1/

LZO build fails on allyesconfig:

lib/built-in.o: In function `lzo1x_1_compress':
lib/lzo/minilzo.c:724: multiple definition of `lzo1x_1_compress'                           fs/built-in.o:fs/reiser4/plugin/compress/minilzo.c:1307: first defined here
ld: Warning: size of symbol `lzo1x_1_compress' changed from 1541 in fs/built-in.o to 244 in lib/built-in.o
lib/built-in.o: In function `lzo1x_decompress':                                            lib/lzo/minilzo.c:885: multiple definition of `lzo1x_decompress'
fs/built-in.o:fs/reiser4/plugin/compress/minilzo.c:1466: first defined here                ld: Warning: size of symbol `lzo1x_decompress' changed from 1047 in fs/built-in.o to 678 in lib/built-in.o
make: *** [.tmp_vmlinux1] Error 1
make: Target `all' not remade because of errors.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
