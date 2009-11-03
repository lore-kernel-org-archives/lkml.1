Return-Path: <linux-kernel-owner+w=401wt.eu-S1752597AbZKCMfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbZKCMfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 07:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbZKCMfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 07:35:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36820 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZKCMfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 07:35:40 -0500
Date: Tue, 3 Nov 2009 10:35:18 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Using build-ids in perf tools was Re: [PATCH -tip perf/probes
	00/10] x86 insn decoder bugfixes
Message-ID: <20091103123518.GA3009@ghostprotocols.net>
References: <20091027204156.30545.96425.stgit@harusame> <20091029085348.GD26970@elte.hu> <20091029191801.CADC3538@magilla.sf.frob.com> <20091103072439.GA19928@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103072439.GA19928@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 03, 2009 at 08:24:39AM +0100, Ingo Molnar escreveu:
> * Roland McGrath <roland@redhat.com> wrote:
> > As Frank mentioned, the kernel's and modules' allocated ELF notes (and 
> > thus build IDs) are already exposed in /sys.  Tools like "eu-unstrip 
> > -nk" use this information today.
> 
> Ah, i didnt realize we link with --build-id already, unconditonally, 
> since v2.6.23 (if ld supports it):
> 
>  | From 18991197b4b588255ccabf472ebc84db7b66a19c Mon Sep 17 00:00:00 2001
>  | Subject: [PATCH] Use --build-id ld option
> 
> So we have an SHA1 build-id already on the vmlinux and on modules, and 
> it's exposed in /sys/*/*/notes. Just have to make use of it in 
> tools/perf too.

I wasn't aware this was done upstream, ass-umed that it was only on
kernel specfiles, will cook up a patch for consideration.

- Arnaldo
