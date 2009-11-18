Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbZKRATz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbZKRATz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 19:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbZKRATz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 19:19:55 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:23184 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436AbZKRATy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 19:19:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zm9MD3mFNB+hgIU+9mq0Q0BVBjRSeT+RA2BweNkrGcyhSiQB+2W8iFg5gMXsY6pvh0
         gbHv+gQrSsoiNiRMAbrVsYa2Tpg75sb9anNKnqXO4pTxqwCsOJksWVXFQROLc9Tfl9vP
         w0NUigNgwQ+AhlOjSxOFqo87UQLHV6Jzf8Ngc=
Date: Wed, 18 Nov 2009 01:19:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 5/7 v6] hw-breakpoints: Rewrite the hw-breakpoints
	layer on top of perf events
Message-ID: <20091118001955.GB8187@nowhere>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <1257694141-5670-6-git-send-email-fweisbec@gmail.com> <1258457443.7816.188.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258457443.7816.188.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 12:30:43PM +0100, Peter Zijlstra wrote:
> On Sun, 2009-11-08 at 16:28 +0100, Frederic Weisbecker wrote:
> > @@ -643,6 +662,8 @@ struct perf_event {
> >  
> >         perf_callback_t                 callback;
> >  
> > +       perf_callback_t                 event_callback;
> > +
> >  #endif /* CONFIG_PERF_EVENTS */
> >  }; 
> 
> And here you add another one.. which is 100% unused in this patch..
> 

Oh, that must be a confusion when I rebased the patches. I'll remove it.

Thanks.

