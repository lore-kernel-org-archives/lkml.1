Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbZKXUUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbZKXUUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932541AbZKXUUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:20:14 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:39501 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbZKXUUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:20:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hWByb6ZvzhOX9lVtlwUDiQ/W+xh+1o3p0t5kwa66TJNJWuPzESxqlnNPMEjdasAr/3
         GMgSQ/NlL0K2UiUhLHULzzscmnIZrvZ4by9se/nK2OgQh7JeGsCHQGJXmwrZ5aSjBVsJ
         fveUjYkc0NuQQ9QlioyDx8zLoSajdALSbqqhg=
Date: Tue, 24 Nov 2009 21:20:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH -tip v5 06/10] kprobes/x86: Cleanup save/restore
	registers
Message-ID: <20091124201957.GD5071@nowhere>
References: <20091123232115.22071.71558.stgit@dhcp-100-2-132.bos.redhat.com> <20091123232204.22071.60562.stgit@dhcp-100-2-132.bos.redhat.com> <20091124025115.GB6752@nowhere> <y0mtywkx76f.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mtywkx76f.fsf@fche.csb>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 10:40:24AM -0500, Frank Ch. Eigler wrote:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > [...]
> >> +#define SAVE_REGS_STRING		\
> >> +#define RESTORE_REGS_STRING		\
> >
> > BTW, do you really need to push/pop every registers
> > before/after calling a probe handler?
> 
> It's part of the definition of a kprobe, that a populated
> pt_regs* value is passed.  Clients can rely on that in order
> to access registers etc.
> 
> - FChE

Yeah I made a confusion. Sorry.

