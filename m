Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab0BDJHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:07:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40355 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755409Ab0BDJHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:07:04 -0500
Date: Thu, 4 Feb 2010 10:06:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Przemys??awPawe??czyk <przemyslaw@pawelczyk.it>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jason Baron <jbaron@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/4] kprobes updates
Message-ID: <20100204090626.GA30663@elte.hu>
References: <20100202214856.4694.72709.stgit@dhcp-100-2-132.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202214856.4694.72709.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, there's this new build warning on x86 defconfig:

arch/x86/kernel/alternative.c: In function 'alternatives_text_reserved':
arch/x86/kernel/alternative.c:402: warning: comparison of distinct pointer types lacks a cast
arch/x86/kernel/alternative.c:402: warning: comparison of distinct pointer types lacks a cast
arch/x86/kernel/alternative.c:405: warning: comparison of distinct pointer types lacks a cast
arch/x86/kernel/alternative.c:405: warning: comparison of distinct pointer types lacks a cast

Caused by:

2cfa197: ftrace/alternatives: Introducing *_text_reserved functions

	Ingo
