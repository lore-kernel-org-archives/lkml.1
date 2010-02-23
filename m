Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0BWUuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 15:50:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420Ab0BWUuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 15:50:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH -tip v3 5/9] perf probe: Use elfutils-libdw for analyzing
	debuginfo
In-Reply-To: Masami Hiramatsu's message of  Monday, 22 February 2010 21:08:53 -0500 <20100223020852.26668.93415.stgit@localhost6.localdomain6>
References: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
	<20100223020852.26668.93415.stgit@localhost6.localdomain6>
Emacs: a Lisp interpreter masquerading as ... a Lisp interpreter!
Message-Id: <20100223204933.F0A9164C@magilla.sf.frob.com>
Date: Tue, 23 Feb 2010 12:49:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	BASIC_CFLAGS += -I/usr/include/elfutils

The normal method is to use:

	#include <elfutils/libdw.h>

Note that <dwarf.h> and <libelf.h> are not in the subdirectory.


Thanks,
Roland
