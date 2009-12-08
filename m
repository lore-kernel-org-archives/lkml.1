Return-Path: <linux-kernel-owner+w=401wt.eu-S1751375AbZLHI7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbZLHI7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZLHI7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:59:35 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:44503 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZLHI7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:59:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Id7sQEUBiBzJPGIn4u0m3FegGEEiCPODU8zjIqH1QlePLmNTxDbf9UvacSwPqGQHpO
         GpBMyc0IXbIgCwe22fJ3n0gt1I/fFq2Ppqg1SE1ZfkjwSSm9QHU3LHnW30A0G44Wdpgc
         UcLC6aVGFg4bn7ATSajJzmMHqrKc9VR5hDLMk=
Date: Tue, 8 Dec 2009 09:59:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 02/13] tracing: Extract calls to
	trace_define_common_fields()
Message-ID: <20091208085935.GA4980@nowhere>
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC49C.8000107@cn.fujitsu.com> <4B1DE5D4.4070805@cn.fujitsu.com> <20091208075731.GC4989@nowhere> <4B1E086E.7040001@cn.fujitsu.com> <20091208081657.GG4989@nowhere> <4B1E0C7A.8070005@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E0C7A.8070005@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 04:21:14PM +0800, Li Zefan wrote:
> > The problem is that we can't know in advance Linus will take
> > a second round of tracing features in this merge window.
> > 
> > I'd rather be careful and keep separating tracing fixes and
> > tracing features.
> > 
> > I'm preparing a separate fix.
> > 
> 
> But there is no functionality change or new feature in this
> patchset, all are cleanups and fixes.


They are not _supposed_ to have functionality change :)
They are mostly cleanups, reorganization, better handling
of interfaces, etc...

All that is in the family of "features". They are improvements
that could possibly induce new bugs.

OTOH, pure fixes are only surgical patches and should not
expand their scope to a reorg or a code cleanup.

Well, it depends, I'm not preaching hard rules. But the
point is we never know if Linus will take another round
of the first category of patches in this merge window.
So it's better to keep pure fixes isolated, at least
they have good chances to keep beeing eligible
after -rc1.

