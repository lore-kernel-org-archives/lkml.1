Return-Path: <linux-kernel-owner+w=401wt.eu-S1752295AbZEJKvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbZEJKvA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 06:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbZEJKuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 06:50:51 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:63192 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbZEJKuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 06:50:50 -0400
Subject: Re: [PATCH 2/5] introduce "struct wait_opts" to simplify do_wait()
 pathes
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090509161901.GB8150@redhat.com>
References: <20090507064637.GA15861@redhat.com>
	 <4A02CBFF.4000901@rsk.demon.co.uk>  <20090509161901.GB8150@redhat.com>
Content-Type: text/plain
Date: Sun, 10 May 2009 11:50:46 +0100
Message-Id: <1241952646.2724.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-09 at 18:19 +0200, Oleg Nesterov wrote:
> sorry for delay Richard,
> 
> On 05/07, Richard Kennedy wrote:
> >
> > Oleg Nesterov wrote:
> > >
> > > +struct wait_opts {
> > > +	enum pid_type		wo_type;
> > > +	struct pid		*wo_pid;
> > > +	int			wo_flags;
> > > +
> > > +	struct siginfo __user	*wo_info;
> > > +	int __user		*wo_stat;
> > > +	struct rusage __user	*wo_rusage;
> > > +
> > > +	int			notask_error;
> > > +};
> > > +
> >
> > Hi Oleg,
> > you can remove 8 bytes of alignment padding from wait_opts on 64bit
> > builds if you reorder it slightly.
> >
> > struct wait_opts {
> > 	enum pid_type 	wo_type;
> > 	int 		wo_flags;
> > 	struct pid	*wo_pid;
> > 	...
> 
> Thanks, didn't think about this...
> 
> This is already in -mm, perhaps you can send the patch to Andrew?
> 
> Oleg.
> 
no problem. I'll send Andrew a patch shortly.

Richard

