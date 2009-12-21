Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbZLUP7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbZLUP7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbZLUP7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:59:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581AbZLUP7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:59:16 -0500
Date: Mon, 21 Dec 2009 17:53:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Roland McGrath <roland@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, utrace-devel@redhat.com,
       Avi Kivity <avi@redhat.com>
Subject: Re: x86: do_debug && PTRACE_SINGLESTEP broken by
	08d68323d1f0c34452e614263b212ca556dae47f
Message-ID: <20091221165304.GA5061@redhat.com>
References: <20091218005650.GA20667@redhat.com> <20091218030601.GB16470@nowhere> <20091218172747.GA10924@redhat.com> <20091218200503.2CA0DF9A4@magilla.sf.frob.com> <20091218223230.GA1853@redhat.com> <4B2F4C58.8010303@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2F4C58.8010303@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21, Jan Kiszka wrote:
>
> Oleg Nesterov wrote:
> >
> > Hmm. Now I see how wrong I was when I said this code is "obviously wrong" ;)

Yes, it is easy to blame the code you don't understand.

My apologies to all.

> > I'll add the debugging printk's and report the output. Sorry for delay,
> > can't do this today.
>
> Can't reproduce, runs fine here with with 2.6.33-rc1 as both host&guest
> and qemu-kvm latest git. Host uses kvm-intel.

Everything runs fine under 2.6.32 as a _host_ kernel. Previously I did
the testing under 2.6.26.5-45.fc9.

Sorry for noise, thanks all for your help.

Oleg.

