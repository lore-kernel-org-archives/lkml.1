Return-Path: <linux-kernel-owner+w=401wt.eu-S1422675AbXDRJNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422675AbXDRJNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422694AbXDRJNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:13:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:21731 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422673AbXDRJNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sIsDYgRtQLp5Cz/7gynE7kecS76U4sdWncQD+NX3F+uj733vAcQ0Jtn9Ur6/1gysfuZ2+tEYX9leJyVKswSf+UeB6VAnqDRnJzjnpjrr1/IAwm5avINnuIafSAQkzx5280UCsckyZ628YTs+fNEXuS8G+fkK4+zFYm6sepHa4mc=
Message-ID: <19a3b7a80704180213i1ac84b2ch2b35220b62e3b67a@mail.gmail.com>
Date: Wed, 18 Apr 2007 11:13:48 +0200
From: "Christoph Pfister" <christophpfister@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Kaffeine problem with CFS
Cc: "=?ISO-8859-9?Q?S.=C7a=F0lar_Onur?=" <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, "Michael Lothian" <mike@fireburn.co.uk>,
       "Christophe Thommeret" <hftom@free.fr>,
       "Jurgen Kofler" <kaffeine@gmx.net>,
       "Ulrich Drepper" <drepper@redhat.com>
In-Reply-To: <20070418090117.GA20764@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070413202100.GA9957@elte.hu>
	 <200704141809.58737.caglar@pardus.org.tr>
	 <20070414160939.GB3099@elte.hu>
	 <200704141959.50076.caglar@pardus.org.tr>
	 <20070415161348.GA30625@elte.hu> <20070415162508.GA4526@elte.hu>
	 <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com>
	 <20070418082744.GA14009@elte.hu>
	 <19a3b7a80704180157g604f4cecna51a49bd1f4c7d38@mail.gmail.com>
	 <20070418090117.GA20764@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/4/18, Ingo Molnar <mingo@elte.hu>:
>
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

QWidget::setUpdatesEnabled() is (wrongly) present in every thread
except the main. So I'm afraid there's nothing which can be done :-/
Btw the main thread is waiting for the first frame being displayed
after the seek.

>         Ingo

Christoph
