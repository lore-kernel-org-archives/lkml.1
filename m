Return-Path: <linux-kernel-owner+w=401wt.eu-S932874AbXBPBcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbXBPBcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932877AbXBPBcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:32:23 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:40055 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932874AbXBPBcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:32:22 -0500
Date: Thu, 15 Feb 2007 20:32:19 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, systemtap@sources.redhat.com,
       ltt-dev@shafik.org
Subject: Re: [PATCH 00/05] Linux Kernel Markers - kernel 2.6.20
Message-ID: <20070216013219.GB12736@Krystal>
References: <1171224207118-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214231201.20918c6b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070214231201.20918c6b.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 19:59:44 up 13 days, 15:07,  3 users,  load average: 1.66, 1.49, 1.32
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Sun, 11 Feb 2007 15:03:22 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > You will find, in the following posts, the latest revision of the Linux Kernel
> > Markers.
> 
> <looks for the documentation>
> 

I guess the header of include/linux/marker.h should go into
Documentation/marker.txt. Will fix. Will be in the next reply.

> And what can I do with these markers?
> 

You can put markers at important locations in the code. They act as
lightweight hooks that can pass an abitrary number of parameters,
described in a printk-like format string, to a function.

They can be used for tracing (LTTng, LKET over SystemTAP), overall
performance accounting (SystemTAP). They could also be used to implement
efficient hooks for SELinux or any other subsystem the would have this
kind of need.

> And once I've done it, are there any userspace applications I can use to
> get the data out in human-usable form?
> 

LTTng and LTTV, SystemTAP (should be updated to the new API).

> It seems to me that these patches aren't sequenced correctly - the kernel won't
> build at each step of the patch sequence.  Maybe I'm mistaken in that.  We prefer
> it this way so that people don't hit wont-compile points when doing bisection searches.

Will fix for the next complete post.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
