Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbZDWTkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbZDWTkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZDWTjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:39:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46691 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401AbZDWTjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:39:41 -0400
Date: Thu, 23 Apr 2009 21:31:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: Chris Zankel <chris@zankel.net>, David Howells <dhowells@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Helge Deller <deller@gmx.de>, Hirokazu Takata <takata@linux-m32r.org>,
       Jeff Dike <jdike@addtoit.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] ptrace: remove PT_DTRACE from arch/* except arch/um
Message-ID: <20090423193153.GA14869@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Roland pointed out, PT_DTRACE is not actually used except in
uml and should die.

Remove it from h8300, avr32, mn10300, parisc, s390, sh, xtensa, m68k,
m68knommu, m32r. The patches are rather simple (but untested), I tried
to split the changes by "category".

With this series arch/um is the only one who uses PT_DTRACE and thinks
task_lock() is needed for ptrace related code. This will be addressed
later (tanks Jeff for your reply).

Oleg.

