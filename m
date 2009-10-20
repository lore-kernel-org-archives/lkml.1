Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZJTRpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZJTRpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 13:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZJTRpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 13:45:13 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:32941 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025AbZJTRpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 13:45:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DXyY1wXBAsR6Q2pZGBRCTk3EB8Cm90Ep7UAZ0QR5unWiVSSnVuX+j5YwIxKTdbUNjy
         E95bbC6bc/e2XLtOAUfgKMrSk8Rp5KZalEe4rJY24bSMu5OZJJT8P1bCw5NbChLNSRcL
         BZDc4xBk1nWCny0DFBdneMFHKLOLBAX00Sg38=
Date: Tue, 20 Oct 2009 19:45:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip tracing/kprobes 0/9] tracing/kprobes, perf: perf
	probe and kprobe-tracer bugfixes
Message-ID: <20091020174508.GC4906@nowhere>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com> <20091017080203.GA4155@elte.hu> <20091017103427.GA31238@elte.hu> <4ADAAF50.9040604@redhat.com> <20091019075103.GF17960@elte.hu> <20091019110055.GA5549@nowhere> <20091019161824.GA10449@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091019161824.GA10449@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 02:18:24PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Mon, Oct 19, 2009 at 01:00:57PM +0200, Frederic Weisbecker escreveu:
> > On Mon, Oct 19, 2009 at 09:51:03AM +0200, Ingo Molnar wrote:
> > > > So, what would you think about using -D (def) and -U (undef) ?
> > > The simpest case should be no extra character at all:
> > >   perf probe schedule
> > Yeah, I really prefer that too.
> 
> /me too
>  
> > If you want more precision, it also means you have you code editor opened
> > and want to set a precise point. Since you also have the absolute
> > line directly displayed by your editor, you don't want to calculate the relative
> > line but rather the absolute one.
> 
> Perhaps this should come with vim/emacs key bindings so that all this
> gets hidden by just opening the source code and pressing
> control+SOMEKEY?
> 
> - Arnaldo


Yep, would be a nice idea.

