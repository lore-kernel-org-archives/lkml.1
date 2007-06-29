Return-Path: <linux-kernel-owner+w=401wt.eu-S933827AbXF2QfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933827AbXF2QfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759002AbXF2QfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:35:11 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:60076 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560AbXF2QfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:35:09 -0400
Date: Fri, 29 Jun 2007 18:36:32 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070629163631.GQ13886@enneenne.com>
References: <20070628084003.GQ13886@enneenne.com> <1183031060.1170.145.camel@pmac.infradead.org> <20070628161450.GD13886@enneenne.com> <1183117082.1170.308.camel@pmac.infradead.org> <20070629150813.GM13886@enneenne.com> <1183130716.1170.347.camel@pmac.infradead.org> <20070629153835.GN13886@enneenne.com> <1183131694.1170.350.camel@pmac.infradead.org> <20070629162346.GO13886@enneenne.com> <1183134208.1170.366.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183134208.1170.366.camel@pmac.infradead.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2007 at 05:23:28PM +0100, David Woodhouse wrote:
> 
> You'll need to put it in an #else case, not in #ifndef __KERNEL__.

Sorry. :)

diff --git a/include/linux/pps.h b/include/linux/pps.h
index 6b53864..9e3af51 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -34,6 +34,8 @@
 #ifndef __KERNEL__
 #include <asm/types.h>
 #include <sys/time.h>
+#else
+#include <linux/time.h>
 #endif
 
 #define PPS_API_VERS_2          2       /* LinuxPPS proposal, dated 2006-05 */

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
