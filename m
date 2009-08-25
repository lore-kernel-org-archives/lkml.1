Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbZHYTwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbZHYTwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbZHYTwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:52:10 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:41197 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbZHYTwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:52:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kUe7vJO3+bTaVubxNV25t5vNeKsFpo7bHCjVe5SSc1tyobWUhn9VFs0Ben57IYgYFO
         D2W/tBRoFLDX1m0vSU2sUAmh5FYp+ZzOq4LHFuY6+c7pmOjFbRrLUR176BohT860R6xQ
         aDAXTsq1xf+UT/r6al0Bhu9RkwhjWmp8VU6tQ=
Date: Tue, 25 Aug 2009 21:52:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 00/12] add syscall tracepoints V3 - s390 arch update
Message-ID: <20090825195203.GB8215@nowhere>
References: <cover.1249932670.git.jbaron@redhat.com> <20090825123111.GD4639@cetus.boeblingen.de.ibm.com> <20090825135228.GD6114@nowhere> <20090825143951.GA28268@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825143951.GA28268@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 04:39:51PM +0200, Heiko Carstens wrote:
> On Tue, Aug 25, 2009 at 03:52:32PM +0200, Frederic Weisbecker wrote:
> > On Tue, Aug 25, 2009 at 02:31:11PM +0200, Hendrik Brueckner wrote:
> > >  		meta = find_syscall_meta((unsigned long)sys_call_table[i]);
> > >  		syscalls_metadata[i] = meta;
> > >  	}
> > We can even probably move most of this code to the core, expect the tiny parts
> > that rely on the arch syscall table.
> > 
> > BTW, perhaps a silly question: would it be hard to have a generic syscall table
> > common to every archs?
> 
> That would cause a lot of churn. Every architecture initializes the syscall
> table (two tables if CONFIG_COMPAT is enabled) differently.
> s390 also only uses 32 bit pointers in the system call table for 64 bit
> kernels, since we know that the functions are within the first 4GB.
> I don't think its worth the effort.


Ok.
Well I remembered about some projects of a unified syscall table but may be
it has been given up for such reasons.

