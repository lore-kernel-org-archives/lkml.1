Return-Path: <linux-kernel-owner+w=401wt.eu-S933534AbYGQXut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbYGQXut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932556AbYGQXu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:50:28 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:28449 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbYGQXu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=JMcq8jsihj5gGavpbYx+lnJjH70l2zy9wr8nTGr3y3CFsKlp8ZVh7PwjNt+qPW3PL9
         X15bzIy70A1Tn3TmL0zzxoxfPrsmF39VB+dR7HbJlb7n7LNZf5UjJry6w8lDKDSm9RY8
         usYXZ96maH+V7pq+2XpxSoUtsIcYn6rcarzB0=
Date: Fri, 18 Jul 2008 02:49:01 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: penberg@cs.helsinki.fi, cl@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] kmemtrace: Core implementation.
Message-ID: <20080717234901.GA5233@localhost>
References: <cover.1216255034.git.eduard.munteanu@linux360.ro> <4472a3f883b0d9026bb2d8c490233b3eadf9b55e.1216255035.git.eduard.munteanu@linux360.ro> <20080717143434.79b33fe9.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717143434.79b33fe9.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 02:34:34PM -0700, Randy Dunlap wrote:
> On Thu, 17 Jul 2008 03:46:45 +0300 Eduard - Gabriel Munteanu wrote:
> 
> > +3) Boot the kmemtrace-enabled kernel if you haven't, preferably in the
> > +'single' runlevel (so that relay buffers don't fill up easily), and run
> > +kmemtrace:
> > +# '$' does not mean user, but root here.
> > +$ mount -t debugfs none /debug
> 
> Please mount at /sys/kernel/debug, i.e., the expected debugfs mount point.
> 

Oh, I did not know that. Thanks, will change accordingly.

> > +$ mount -t proc none /proc
> > +$ cd path/to/kmemtrace-user/
> > +$ ./kmemtraced
> > +Wait a bit, then stop it with CTRL+C.
> > +$ cat /debug/kmemtrace/total_overruns	# Check if we didn't overrun, should
> > +					# be zero.
> > +$ (Optionally) [Run kmemtrace_check separately on each cpu[0-9]*.out file to
> > +		check its correctness]
> > +$ ./kmemtrace-report
> > +
> > +Now you should have a nice and short summary of how the allocator performs.
> 
> 
> Otherwise looks nice.  Thanks.
> 
> ---
> ~Randy
> Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
> http://linuxplumbersconf.org/
