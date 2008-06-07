Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYFGUZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYFGUZd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 16:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYFGUZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 16:25:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:6024 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbYFGUZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 16:25:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Sfa9CxWZtzMnzdm284Fwm7bT4rt3IQbdsUGSsKMARhF2iXy/jIJysQcGosTeK/QbAW
         HwK2QBpHlxyhVNDFM+najCyJ7ib/RCCi/LU8usgawSHYHmOPJdBF8OXSOOlRlZTdn46s
         y7O+grvEtLmFi2woAATnIdMemSDtQuKFb0kCg=
Date: Sat, 7 Jun 2008 22:25:17 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: wrong hardlink count in /proc
Message-ID: <20080607222517.30c11413@Varda>
In-Reply-To: <20080607200818.GI5609@1wt.eu>
References: <20080607193424.GA25998@redhat.com>
	<20080607194604.GH5609@1wt.eu>
	<20080607195042.GB25998@redhat.com>
	<20080607220418.713fbbe5@Varda>
	<20080607200818.GI5609@1wt.eu>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 7 Jun 2008 22:08:18 +0200
Willy Tarreau <w@1wt.eu> escribió:

> On Sat, Jun 07, 2008 at 10:04:18PM +0200, Alejandro Riveira Fernández wrote:
> > El Sat, 7 Jun 2008 15:50:42 -0400
> > Dave Jones <davej@redhat.com> escribió:
> > 
> > > On Sat, Jun 07, 2008 at 09:46:04PM +0200, Willy Tarreau wrote:
> > >  > On Sat, Jun 07, 2008 at 03:34:24PM -0400, Dave Jones wrote:
> > >  > > In 2.6.25, 'find /proc/ -name foo' will print out ..
> > >  > > 
> > >  > > find: WARNING: Hard link count is wrong for /proc/1: this may be a bug
> > >  > > in your filesystem driver.  Automatically turning on find's -noleaf
> > >  > > option.  Earlier results may have failed to include directories that
> > >  > > should have been searched.
> > >  > 
> > >  > I also encountered this one. I think it is the one which 2.6.25.6 stable
> > >  > patch 42/50 fixes.
> > > 
> > > Ah, great.   I just noticed that .26rc doesn't seem affected, so sounds good.
> > 
> >  well on my ubuntu box i get with .26-rc5
> > 
> >  [alex@Varda:kernel/linux-2.6]$ uname -a                      
> >  Linux Varda 2.6.26-rc5 #1 SMP PREEMPT Thu Jun 5 10:59:53 CEST 2008 x86_64 GNU/Linux
> >  [alex@Varda:kernel/linux-2.6]$ LC_ALL=C sudo find /proc -name foo                                              
> >  find: WARNING: Hard link count is wrong for /proc/1: this may be a bug in your filesystem driver.  Automatically turning   on find's -noleaf option.  Earlier results may have failed to include directories that should have been searched.
> >  find: /proc/5257/net: Invalid argument
> >  [alex@Varda:kernel/linux-2.6]$ 
> 
> It was merged after 2.6.26-rc5. Commit id is aed54175 which is post-rc5.
 
 Thank you

> 
> Regards,
> Willy

 Alejandro
> 
