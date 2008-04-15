Return-Path: <linux-kernel-owner+w=401wt.eu-S1764605AbYDODzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764605AbYDODzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 23:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762626AbYDODzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 23:55:33 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:35361 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762514AbYDODzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 23:55:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qRZvjVDJ8JYA5tVPGA3cWonCX+XGNd6J/hAyp8WPWy+zhAdI3Cnx/F8538ccnDd13os/ebrLJ0+FKHlON0kXyRHGLO8nkC9Q3SxwKWOPWL8uo1dqgi9mQs03qwMbV6vwUf8+aeAUF1ulUUGs8F8ZVXQcJm4UW/82FXUatxvkNAI=
Message-ID: <a44ae5cd0804142055tb955431ne904862043a01d6d@mail.gmail.com>
Date: Mon, 14 Apr 2008 23:55:32 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: =?WINDOWS-1252?Q?Re:_2.6.25-rc8-mm2_--_kernel/sched.c:8294:_error:_?= =?WINDOWS-1252?Q?unknown_field_=91read=5Fuint=92_specified_in_initializer?=
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Paul Menage" <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080414193855.74ea0d88.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0804110648g3256805fob917f31eeff4f6db@mail.gmail.com>
	 <1207932902.7157.4.camel@twins>
	 <6599ad830804111146k2c3db442y3708f95a3fbee83@mail.gmail.com>
	 <1207940124.7427.1.camel@twins>
	 <a44ae5cd0804141928p2fbf4006j5d365918e3b8073e@mail.gmail.com>
	 <20080414193855.74ea0d88.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:38 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 14 Apr 2008 22:28:27 -0400 "Miles Lane" <miles.lane@gmail.com> wrote:
>
>  > Hmm.  This is showing up in 2.6.25-rc9 and looks related to the
>  > problem in 2.6.25-rc9-mm2:
>  >
>  >   CC      kernel/sched.o
>  > kernel/sched.c:7988: error: unknown field 'read_u64' specified in initializer
>  > kernel/sched.c:7988: error: 'cpu_shares_read_u64' undeclared here (not
>  > in a function)
>  > kernel/sched.c:7989: error: unknown field 'write_u64' specified in initializer
>  > kernel/sched.c:7989: error: 'cpu_shares_write_u64' undeclared here
>  > (not in a function)
>  > kernel/sched.c:7995: error: unknown field 'read_s64' specified in initializer
>  > kernel/sched.c:7995: warning: initialization makes integer from
>  > pointer without a cast
>  > kernel/sched.c:7996: error: unknown field 'write_s64' specified in initializer
>  > kernel/sched.c:7996: warning: initialization from incompatible pointer type
>  > kernel/sched.c:8000: error: 'cpu_rt_period_read_uint' undeclared here
>  > (not in a function)
>  > kernel/sched.c:8001: error: 'cpu_rt_period_write_uint' undeclared here
>  > (not in a function)
>
>  I'm suspecting that you applied the -mm patch, then you applied
>  cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch,
>  then you reverted the -mm patch but didn't revert
>  cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64-fix.patch.
>

Hmm.  Bizarro.  I have no recollection of applying such a patch, but maybe
I need to get some more sleep.  I just downloaded the whole 2.6.25-rc9
tarball and lo and behold, it worked.

Sorry for the noise,

        Miles
