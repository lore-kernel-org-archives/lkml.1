Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYG1NHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYG1NHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYG1NGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:06:55 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:35766 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbYG1NGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:06:55 -0400
Date: Mon, 28 Jul 2008 16:06:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Huang Ying <ying.huang@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: sh kexec build error
Message-ID: <20080728130613.GB30612@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3ab83521378268044a448113c6aa9a9e245f4d2f (kexec jump)
causes the following build error on sh:

<--  snip  -->

...
  CC      kernel/kexec.o
{standard input}: Assembler messages:
{standard input}:1518: Error: offset to unaligned destination
make[2]: *** [kernel/kexec.o] Error 1

<--  snip  -->

If I understand the assembler correctly it fails at
include/asm-sh/kexec.h:59

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

