Return-Path: <linux-kernel-owner+w=401wt.eu-S1760426AbZDCVd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426AbZDCVd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbZDCVdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:33:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51083 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757386AbZDCVdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:33:44 -0400
Message-ID: <49D680D0.1090701@redhat.com>
Date: Fri, 03 Apr 2009 17:34:08 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH -tip 2/6 V4.1] x86: add arch-dep register and stack access
  API to ptrace
References: <49D4F4DF.1040605@redhat.com>	<20090402234835.GA6112@nowhere>	<49D6331D.6000505@redhat.com> <20090403202004.3A2B1FC3AB@magilla.sf.frob.com>
In-Reply-To: <20090403202004.3A2B1FC3AB@magilla.sf.frob.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
>> +static struct pt_regs_offset regoffset_table[] = {
> 
>          ^ const

Oops, exactly.
Perhaps, I need to update insn.c to make bitmap tables
"static const" too.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

