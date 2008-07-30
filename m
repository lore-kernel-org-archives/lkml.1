Return-Path: <linux-kernel-owner+w=401wt.eu-S1761879AbYGaAKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761879AbYGaAKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761979AbYGaAJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:09:43 -0400
Received: from ns.suse.de ([195.135.220.2]:38299 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761467AbYGaAJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:09:41 -0400
Date: Wed, 30 Jul 2008 16:58:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 17/62] Fix typos from signal_32/64.h merge
Message-ID: <20080730235824.GQ12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-typos-from-signal_32-64.h-merge.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

commit 723edb5060855ef36ddeca51a070784b0e0d16df upstream

Fallout from commit 33185c504f8e521b398536b5a8d415779a24593c ("x86:
merge signal_32/64.h")

Thanks to Dick Streefland who provided an useful testcase on
http://lkml.org/lkml/2008/3/17/205 (only applicable to 2.6.24.x), that
helped a lot as a deterministic way to bisect an issue that leaded to
this fix.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-x86/signal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/asm-x86/signal.h
+++ b/include/asm-x86/signal.h
@@ -181,12 +181,12 @@ typedef struct sigaltstack {
 #ifdef __KERNEL__
 #include <asm/sigcontext.h>
 
-#ifdef __386__
+#ifdef __i386__
 
 #define __HAVE_ARCH_SIG_BITOPS
 
 #define sigaddset(set,sig)		    \
-	(__builtin_constantp(sig)	    \
+	(__builtin_constant_p(sig)	    \
 	 ? __const_sigaddset((set), (sig))  \
 	 : __gen_sigaddset((set), (sig)))
 

-- 
