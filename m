Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab0BWVAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 16:00:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0BWVAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 16:00:41 -0500
Subject: Re: [PATCH -tip v3 5/9] perf probe: Use elfutils-libdw for
 analyzing debuginfo
From: Peter Zijlstra <peterz@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20100223204933.F0A9164C@magilla.sf.frob.com>
References: <20100223020818.26668.79685.stgit@localhost6.localdomain6>
	 <20100223020852.26668.93415.stgit@localhost6.localdomain6>
	 <20100223204933.F0A9164C@magilla.sf.frob.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Feb 2010 22:00:09 +0100
Message-ID: <1266958809.11845.817.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 12:49 -0800, Roland McGrath wrote:
> > +	BASIC_CFLAGS += -I/usr/include/elfutils
> 
> The normal method is to use:
> 
> 	#include <elfutils/libdw.h>
> 
> Note that <dwarf.h> and <libelf.h> are not in the subdirectory.

We've had funny issues with distro's being inconsistent in placing those
files, so we chose this route of a direct include and playing games with
the include path to make it work.

