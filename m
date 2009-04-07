Return-Path: <linux-kernel-owner+w=401wt.eu-S1758684AbZDGFFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758684AbZDGFFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbZDGFFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:05:43 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36982 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZDGFFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:05:42 -0400
Date: Tue, 7 Apr 2009 10:12:06 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [RFC][PROTO][PATCH -tip 1/7] kprobes: use list instead of
	hlist for insn_pages
Message-ID: <20090407044206.GC4216@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <49DA7710.7040008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DA7710.7040008@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 06, 2009 at 05:41:36PM -0400, Masami Hiramatsu wrote:
> Use struct list instead of struct hlist for managing insn_pages, because
> insn_pages doesn't use hash table.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>

This change can go in independent of djprobes.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
