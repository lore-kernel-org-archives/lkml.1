Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbXJ2Vvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbXJ2Vvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 17:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXJ2Vvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 17:51:42 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:41745 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbXJ2Vvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 17:51:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAGzyJUdMQWvU/2dsb2JhbACBWo5W
Date: Mon, 29 Oct 2007 17:51:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Sam Ravnborg <sam@ravnborg.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>
Subject: [RFC] Create instrumentation directory (git repository)
Message-ID: <20071029215138.GA4233@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:08:42 up 91 days, 19:27,  4 users,  load average: 5.31, 2.23, 1.19
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since we already have the Instrumentation menu in
kernel/Kconfig.instrumentation and instrumentation code all over the
kernel tree:

arch/*/oprofile/*.c
kernel/kprobes.c
arch/*/kernel/kprobes.c
kernel/marker.c
kernel/profile.c
kernel/lockdep.c
vm/vmstat.c
block/blktrace.c
drivers/base/power/trace.c

We could move them to

instrumentation/
arch/*/instrumentation/

Therefore, we could also move the kprobes and marker samples under

instrumentation/samples/

Here is a link to a git repository containing the changes, based on
2.6.24-rc1:

git://ltt.polymtl.ca/linux-2.6-instrumentation.git instrumentation-for-linus
(the interesting range is : v2.6.24-rc1..instrumentation-for-linus)

Through the gitweb interface:
http://ltt.polymtl.ca/cgi-bin/gitweb.cgi?p=linux-2.6-instrumentation.git

Feedback is appreciated. Sorry for the huge CC list, but the change
involves many maintainers.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
