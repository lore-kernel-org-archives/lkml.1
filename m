Return-Path: <linux-kernel-owner+w=401wt.eu-S1756270AbZIVLvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbZIVLvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 07:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbZIVLvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 07:51:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:44425 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756239AbZIVLvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 07:51:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18EyVYYuuUEnS2r8hXxsKGS8wmDTWMqIVmnw89wps
	evJFSeTKkvjqY+
Subject: Re: mailing list for trace users
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Avi Kivity <avi@redhat.com>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <1253617179.7695.17.camel@twins>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com>  <1253617179.7695.17.camel@twins>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 13:51:37 +0200
Message-Id: <1253620297.13917.28.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 12:59 +0200, Peter Zijlstra wrote:

> We need a /proc/modules parser that then also locates and loads .ko
> files which aren't stripped.
> 
> I think Mike played around with that a bit.

Nope.

> The typical problem is that people use 'make INSTALL_MOD_STRIP=1
> modules_install' to install their modules, because otherwise the initrd
> thingies explode, the side effect is that the !initrd modules are
> stripped too.

Oh, yeah, that would explain it.  Stripped module is a nogo.

	-Mike

