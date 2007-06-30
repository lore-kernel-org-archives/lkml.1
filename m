Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbXF3TId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbXF3TId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 15:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbXF3TI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 15:08:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbXF3TIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 15:08:25 -0400
Date: Sat, 30 Jun 2007 12:08:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux@horizon.com
Cc: ak@suse.de, bk@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, michal.k.k.piotrowski@gmail.com
Subject: Re: 2.6.22-rcX Transmeta/APM regression
Message-Id: <20070630120803.99a124e4.akpm@linux-foundation.org>
In-Reply-To: <20070630185706.3979.qmail@science.horizon.com>
References: <200706301126.41179.ak@suse.de>
	<20070630185706.3979.qmail@science.horizon.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 Jun 2007 14:57:06 -0400 linux@horizon.com wrote:

> > --- a/arch/i386/kernel/cpu/mtrr/generic.c~i386-mtrr-crash-fix
> > +++ a/arch/i386/kernel/cpu/mtrr/generic.c
> > @@ -65,7 +65,8 @@ get_fixed_ranges(mtrr_type * frs)
> >  
> >  void mtrr_save_fixed_ranges(void *info)
> >  {
> > -	get_fixed_ranges(mtrr_state.fixed_ranges);
> > +	if (cpu_has_mtrr)
> > +		get_fixed_ranges(mtrr_state.fixed_ranges);
> >  }
> >  
> >  static void print_fixed(unsigned base, unsigned step, const mtrr_type*types)
> 
> This works great, thanks!  Please consider the regression diagnosed and fixed.

OK, thanks.  I'll scoot that linuswards later today.
