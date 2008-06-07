Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbYFGUIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbYFGUIm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 16:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYFGUIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 16:08:36 -0400
Received: from 1wt.eu ([62.212.114.60]:1526 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbYFGUIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 16:08:35 -0400
Date: Sat, 7 Jun 2008 22:08:18 +0200
From: Willy Tarreau <w@1wt.eu>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: wrong hardlink count in /proc
Message-ID: <20080607200818.GI5609@1wt.eu>
References: <20080607193424.GA25998@redhat.com> <20080607194604.GH5609@1wt.eu> <20080607195042.GB25998@redhat.com> <20080607220418.713fbbe5@Varda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080607220418.713fbbe5@Varda>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 10:04:18PM +0200, Alejandro Riveira Fernández wrote:
> El Sat, 7 Jun 2008 15:50:42 -0400
> Dave Jones <davej@redhat.com> escribió:
> 
> > On Sat, Jun 07, 2008 at 09:46:04PM +0200, Willy Tarreau wrote:
> >  > On Sat, Jun 07, 2008 at 03:34:24PM -0400, Dave Jones wrote:
> >  > > In 2.6.25, 'find /proc/ -name foo' will print out ..
> >  > > 
> >  > > find: WARNING: Hard link count is wrong for /proc/1: this may be a bug
> >  > > in your filesystem driver.  Automatically turning on find's -noleaf
> >  > > option.  Earlier results may have failed to include directories that
> >  > > should have been searched.
> >  > 
> >  > I also encountered this one. I think it is the one which 2.6.25.6 stable
> >  > patch 42/50 fixes.
> > 
> > Ah, great.   I just noticed that .26rc doesn't seem affected, so sounds good.
> 
>  well on my ubuntu box i get with .26-rc5
> 
>  [alex@Varda:kernel/linux-2.6]$ uname -a                      
>  Linux Varda 2.6.26-rc5 #1 SMP PREEMPT Thu Jun 5 10:59:53 CEST 2008 x86_64 GNU/Linux
>  [alex@Varda:kernel/linux-2.6]$ LC_ALL=C sudo find /proc -name foo                                              
>  find: WARNING: Hard link count is wrong for /proc/1: this may be a bug in your filesystem driver.  Automatically turning   on find's -noleaf option.  Earlier results may have failed to include directories that should have been searched.
>  find: /proc/5257/net: Invalid argument
>  [alex@Varda:kernel/linux-2.6]$ 

It was merged after 2.6.26-rc5. Commit id is aed54175 which is post-rc5.

Regards,
Willy

