Return-Path: <linux-kernel-owner+w=401wt.eu-S1763798AbYF3SZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763798AbYF3SZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYF3SZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:25:00 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:60655 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYF3SY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:24:59 -0400
Date: Mon, 30 Jun 2008 11:22:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] fork and exit: need to include iocontext.h
Message-Id: <20080630112222.f103e477.randy.dunlap@oracle.com>
In-Reply-To: <20080630180506.GC23739@elte.hu>
References: <20080630105458.7c95e195.randy.dunlap@oracle.com>
	<20080630180506.GC23739@elte.hu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2008 20:05:06 +0200 Ingo Molnar wrote:

> 
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix fork and exit build errors: they need to include iocontext.h:
> > 
> > linux-next-20080630/kernel/fork.c: In function 'copy_process':
> > linux-next-20080630/kernel/fork.c:1237: error: implicit declaration of function 'put_io_context'
> > linux-next-20080630/kernel/exit.c: In function 'do_exit':
> > linux-next-20080630/kernel/exit.c:992: error: implicit declaration of function 'exit_io_context'
> 
> i havent seen this one - do you know by chance which commit triggers it?


Sorry, no idea which commit.

In 50 randconfigs today (next-20080630), I saw this one 12 times.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
