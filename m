Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbZADQmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbZADQmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbZADQmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:42:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:58869 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbZADQmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:42:38 -0500
Subject: Re: [PATCH -tip 0/7] x86 rename all fields mpc_X to X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       astarikovskiy@suse.de, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1231085890.5517.7.camel@jaswinder.satnam>
References: <1231085890.5517.7.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 22:10:25 +0530
Message-Id: <1231087225.5517.34.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 22:02 +0530, Jaswinder Singh Rajput wrote:
> The following changes since commit 6b03a9912ce53af2d94621e8ac2ef217676db70c:
>   Ingo Molnar (1):
>         Merge branch 'x86/cleanups'

I am sorry, here is the correct one:

The following changes since commit 11e868434fbab0852056cfe006f1b06c4e1ff5dc:
  Ingo Molnar (1):
        Merge branch 'x86/cleanups'

Jaswinder Singh Rajput (7):
      x86: rename all fields of mpc_iopic mpc_X to X
      x86: rename all fields of mpc_lintsrc mpc_X to X
      x86: rename all fields of mpc_intsrc mpc_X to X
      x86: rename all fields of mpc_cpu mpc_X to X
      x86: rename all fields of mpc_bus mpc_X to X
      x86: rename all fields of mpc_oemtable oem_X to X
      x86: rename all fields of mpc_table mpc_X to X

 arch/x86/include/asm/mpspec_def.h |   88 +++++++-------
 arch/x86/kernel/mpparse.c         |  251 ++++++++++++++++++-------------------
 arch/x86/kernel/numaq_32.c        |   27 ++--
 arch/x86/kernel/visws_quirks.c    |   28 ++---
 arch/x86/mach-generic/es7000.c    |    4 +-
 5 files changed, 196 insertions(+), 202 deletions(-)


