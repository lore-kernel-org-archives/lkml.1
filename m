Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYARGlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYARGlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 01:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYARGlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 01:41:42 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:64375 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYARGlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 01:41:42 -0500
Message-Id: <200801180640.m0I6enPI029212@www262.sakura.ne.jp>
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Zan Lynx <zlynx@acm.org>,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Jan 2008 15:40:49 +0900
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp> <20080117181935.02294863.akpm@linux-foundation.org> <200801180319.m0I3Ju9N089501@www262.sakura.ne.jp> <20080117204247.5318e500.akpm@linux-foundation.org>
In-Reply-To: <20080117204247.5318e500.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andrew Morton wrote:
> It could be compiler version dependent.  I used gcc-4.1.0.  Which version
> were you and Zan using please?

I'm using gcc 3.3.5 on Debian/Sarge .

By the way, 2.6.24-rc8-mm1 doesn't hang with a kernel config

# make -s allnoconfig
# make -s menuconfig

  Set [*] to all entries in "Kernel hacking  --->" section
  (except "KGDB: kernel debugging with remote gdb").

# make -s && make -s install

Regards.
