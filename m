Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZHXLLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZHXLLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 07:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbZHXLLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 07:11:54 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61333 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbZHXLLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 07:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dEI6LuI0mwi+dIBY8LbHhfyxrq5mkB423mf+pUigDqWPYjkNX2nkGvJZFAzPED2yno
         zfLEug6B1XS2OOb6ShqVCxUTIq9Ql+9CHG5PDm1sJ7DUnT8WzdCgWXnj9FOcmVVO7Jsv
         35dSDGaC42E8oygvX/OfIF/mXQsn7dQwU6ad4=
Date: Mon, 24 Aug 2009 13:11:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH v3 1/4] tracing: Rename TIF_SYSCALL_FTRACE->_TRACEPOINT
Message-ID: <20090824111148.GA6130@nowhere>
References: <1250795373-32363-1-git-send-email-jistone@redhat.com> <1250917125-6174-1-git-send-email-jistone@redhat.com> <1250917125-6174-2-git-send-email-jistone@redhat.com> <20090823211625.GH6256@nowhere> <20090824084245.GF2424@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824084245.GF2424@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 10:42:45AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Fri, Aug 21, 2009 at 09:58:42PM -0700, Josh Stone wrote:
> >
> > > This thread flag is no longer specific to just ftrace, so 
> > > TIF_SYSCALL_TRACEPOINT may be a more apt name.
> > 
> > Adding Paul Mundt <lethal@linux-sh.org> in Cc, the sh tree also 
> > has the syscalls tracing support (in a seperate branch).
> 
> Btw., is there an URI for that separate branch?
> 
> 	Ingo

I guess it's:

git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git \
	sh/ftrace

