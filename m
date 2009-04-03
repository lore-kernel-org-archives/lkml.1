Return-Path: <linux-kernel-owner+w=401wt.eu-S936426AbZDCUYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936426AbZDCUYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 16:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762534AbZDCUXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 16:23:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759692AbZDCUXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 16:23:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH -tip 2/6 V4.1] x86: add arch-dep register and stack access  API to ptrace
In-Reply-To: Masami Hiramatsu's message of  Friday, 3 April 2009 12:02:37 -0400 <49D6331D.6000505@redhat.com>
References: <49D4F4DF.1040605@redhat.com>
	<20090402234835.GA6112@nowhere>
	<49D6331D.6000505@redhat.com>
X-Shopping-List: (1) Puerile inadvertent watch trout
   (2) Opulent sample gravy
   (3) Emphatic soft-serve
Message-Id: <20090403202004.3A2B1FC3AB@magilla.sf.frob.com>
Date: Fri,  3 Apr 2009 13:20:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static struct pt_regs_offset regoffset_table[] = {

         ^ const
