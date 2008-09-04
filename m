Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbYIDSMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbYIDSMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYIDSME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:12:04 -0400
Received: from dakia3.marvell.com ([65.219.4.28]:60172 "EHLO
	dakia3.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYIDSMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:12:03 -0400
X-Greylist: delayed 1087 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2008 14:12:03 EDT
X-ASG-Debug-ID: 1220550835-689401eb0000-xx1T2L
X-Barracuda-URL: http://dakia3.marvell.com:80/cgi-bin/mark.cgi
X-Barracuda-BBL-IP: 10.68.76.198
X-Barracuda-RBL-IP: 10.68.76.198
X-ASG-Orig-Subj: Building Kernel with -O0
Subject: Building Kernel with -O0
From: "Keith A. Prickett" <keithp@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Sep 2008 10:50:53 -0700
Message-Id: <1220550653.15123.6.camel@CV-LAB2>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1220550835
X-Barracuda-Virus-Scanned: by Marvell Mail Gateway at marvell.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at some changes to the 2.6.26.y kernel in "compiler-gcc.h"
and had some questions.
( http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=commitdiff;h=ae3a0064e6d69068b1c9fd075095da062430bda9 )

I was attempting to cross-compile Linux for a Marvell core with
Optimizations turned off and ran across an error due to the
__attribute__((always_inline)) attribute.

It looks like the default behavior used to always have this feature on,
but Ingo committed some changes that allows this behavior to be turned
off (With the correct Kconfig file changes).

I'm VERY new to Linux but was wondering if there was a way (config
option) to turn this inline attribute off in previous versions of the
kernel besides these new macros.  It seems building with optimization
level 0 should be a natural thing for kernel driver developers to do for
debugging purposes.

In summary: I want to compile with optimizations off and the compile is
failing now when I try this.  How can this be resolved?


For reference:
- Stable Kernel 2.6.26
- I'm using arm-marvell-eabi-gcc 4.1.1
- Compiling for ARM architecture
- Neither CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING nor
CONFIG_OPTIMIZE_INLINING are on (or even options in the ARM
architecture)
- The error I receive is:
 "sorry, unimplemented: inlining failed in call to '<inline function>':
function body not available"


Thanks in advance,
--
Keith Prickett
