Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbZEIQYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbZEIQYX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZEIQXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:23:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60594 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbZEIQXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:23:47 -0400
Date: Sat, 9 May 2009 18:19:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] introduce "struct wait_opts" to simplify do_wait()
	pathes
Message-ID: <20090509161901.GB8150@redhat.com>
References: <20090507064637.GA15861@redhat.com> <4A02CBFF.4000901@rsk.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A02CBFF.4000901@rsk.demon.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry for delay Richard,

On 05/07, Richard Kennedy wrote:
>
> Oleg Nesterov wrote:
> >
> > +struct wait_opts {
> > +	enum pid_type		wo_type;
> > +	struct pid		*wo_pid;
> > +	int			wo_flags;
> > +
> > +	struct siginfo __user	*wo_info;
> > +	int __user		*wo_stat;
> > +	struct rusage __user	*wo_rusage;
> > +
> > +	int			notask_error;
> > +};
> > +
>
> Hi Oleg,
> you can remove 8 bytes of alignment padding from wait_opts on 64bit
> builds if you reorder it slightly.
>
> struct wait_opts {
> 	enum pid_type 	wo_type;
> 	int 		wo_flags;
> 	struct pid	*wo_pid;
> 	...

Thanks, didn't think about this...

This is already in -mm, perhaps you can send the patch to Andrew?

Oleg.

