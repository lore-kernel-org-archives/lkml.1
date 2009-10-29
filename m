Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZJ2RQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZJ2RQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 13:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756186AbZJ2RQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 13:16:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbZJ2RQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 13:16:34 -0400
Date: Thu, 29 Oct 2009 13:15:51 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip perf/probes 00/10] x86 insn decoder bugfixes
Message-ID: <20091029171551.GA8985@redhat.com>
References: <20091027204156.30545.96425.stgit@harusame> <20091029085348.GD26970@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091029085348.GD26970@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Oct 29, 2009 at 09:53:48AM +0100, Ingo Molnar wrote:
> [...]
> Thirdly, i think we should expose the build-id of the kernel and the 
> path to the vmlinux (and modules) via /proc/build-id or so. [...]

See "/sys/kernel/notes" and "/sys/module/*/notes".

- FChE

