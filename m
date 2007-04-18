Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbXDRJM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbXDRJM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXDRJM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:12:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:59055 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751610AbXDRJM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:12:56 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/W4JpbbXTW+PdWs/IVMif/2v2XHwFBG3tby4euRn
	2rNU4cGJEb0Ob8
Subject: Re: Kaffeine problem with CFS
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Pfister <christophpfister@gmail.com>,
       =?iso-8859-9?Q?S=2E=C7a=F0lar?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20070418090117.GA20764@elte.hu>
References: <20070413202100.GA9957@elte.hu>
	 <200704141809.58737.caglar@pardus.org.tr> <20070414160939.GB3099@elte.hu>
	 <200704141959.50076.caglar@pardus.org.tr> <20070415161348.GA30625@elte.hu>
	 <20070415162508.GA4526@elte.hu>
	 <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com>
	 <20070418082744.GA14009@elte.hu>
	 <19a3b7a80704180157g604f4cecna51a49bd1f4c7d38@mail.gmail.com>
	 <20070418090117.GA20764@elte.hu>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 11:12:51 +0200
Message-Id: <1176887571.15820.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 11:01 +0200, Ingo Molnar wrote:
> * Christoph Pfister <christophpfister@gmail.com> wrote:
> 
> > >backtrace:
> > >
> > > #0  0xffffe410 in __kernel_vsyscall ()
> > > #1  0x4a2510c6 in pthread_cond_wait@@GLIBC_2.3.2 () from 
> > > /lib/libpthread.so.0
> > > #2  0xb79fd1a8 in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
> > > #3  0xb7a030ab in QWidget::setUpdatesEnabled () from /usr/lib/libxine.so.1
> > > #4  0x4a24d2db in start_thread () from /lib/libpthread.so.0
> > > #5  0x4a05820e in clone () from /lib/libc.so.6
> > 
> > This backtrace is useless - QWidget::setUpdatesEnabled() is certainly 
> > _not_ defined in libxine. So the function names in #2 and #3 are wrong 
> > because the addresses seem to belong to libxine.
> 
> are the updated backtraces in the followup mail i just sent more useful? 
> (I still have that stuck session running so i can whatever debugging 
> you'd like to see done.)

The xine website release note says there are problems with playback with
xine-lib version 1.1.5, so people encountering this may want to check to
see if they're running 1.1.5, and either upgrade to the latest, or
downgrade to 1.1.4.

<snippet from xine website>

18.04.2007   xine-lib 1.1.6   A new xine-lib version is now available.
This is mainly a bug-fix release; 1.1.5 has CD audio and DVD playback
problems and a couple of X-related build problems.

	-Mike

