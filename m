Return-Path: <linux-kernel-owner+w=401wt.eu-S934446AbXGLQFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbXGLQFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 12:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbXGLQF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 12:05:27 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45319
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756868AbXGLQFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 12:05:25 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Li Yang-r58472" <LeoLi@freescale.com>
Subject: [PATCH] Chinese Language Maintainer
Date: Thu, 12 Jul 2007 12:05:19 -0400
User-Agent: KMail/1.9.6
Cc: "Gerrit Huizenga" <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
References: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>
In-Reply-To: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707121205.20959.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Proposed patch adding Li Yang to MAINTAINERS, and Documentation
describing what a language maintainer is.

Signed-off-by: Rob Landley <rob@landley.net>

--

On Thursday 12 July 2007 9:53:54 am Li Yang-r58472 wrote:

> > > I'm trying to establish.
> >
> > A list works fine as a point of contact.  I note that in general,
> maintainers
> > are individuals (who delegate like mad, of course), because otherwise
> agenda
> > items languish with everyone thinking it's someone else's
> responsibility.
>
> Got it.  I can do it as long as it doesn't consume too much time.  :)

Woot!  See attached patch and sign-off-by if you want the job. :)

The bit about "the maintainer forwards, not the list" is a suggestion to
prevent duplicates.  It doesn't mean you can't delegate, just that if it's
open season on the list translating stuff _and_ forwarding it, then
linux-kernel will get dupes.  (Plus other maintainers are more likely
to pay attention to somebody they've heard from before.)

Greg KH had entire an OLS presentation about how the developer ->
maintainer -> subsystem -> anderew+linus forwarding is more
an ideal than a reality, but at least it gives us a frame of reference
to diverge from:
http://lwn.net/Articles/240402/

diff -r edfd2d6f670d MAINTAINERS
--- a/MAINTAINERS	Tue Jul 10 17:51:13 2007 -0700
+++ b/MAINTAINERS	Thu Jul 12 11:51:19 2007 -0400
@@ -2146,6 +2146,13 @@ W:	http://auxdisplay.googlepages.com/
 W:	http://auxdisplay.googlepages.com/
 S:	Maintained
 
+LANGUAGE (CHINESE)
+P:	Li Yang
+M:	LeoLi@freescale.com
+L:	linux-kernel@zh-kernel.org
+W:	http://zh-kernel.org
+S:	Maintained
+
 LAPB module
 L:	linux-x25@vger.kernel.org
 S:	Orphan
--- /dev/null	2007-04-23 11:59:00.000000000 -0400
+++ linux-2.6/Documentation/language-maintainers.txt	2007-07-12 11:49:20.000000000 -0400
@@ -0,0 +1,20 @@
+The langauges in which the Linux kernel is developed are C and English.
+(Note that Linus Torvalds' native language is Swedish, yet he chose
+to hold technical discussions in English.)
+
+The job of a language maintainer is to provide a point of contact for
+non-english speaking developers who wish to merge their patches into the
+Linux kernel.  Each language needs a specific language maintainer, who
+accepts non-english patch submissions on behalf of the Linux kernel.
+
+A language maintainer accepts patches to the Linux kernel, written in C, from
+authors who do not also speak English.  The language maintainer translates the
+description of each patch into English, forwards the patches to linux-kernel
+and to the appropriate maintainers for inclusion in the Linux kernel, and
+translates questions and replies about such patches as part of the
+patch review process.
+
+Some language maintainers provide a mailing list as a point of contact, to
+distribute the translation work, but the maintainer is still the person who
+ultimately forwards the results (to prevent duplicates), and the one to contact
+if patches and questions don't get translated and forwarded in a timely fashion.

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
