Return-Path: <linux-kernel-owner+w=401wt.eu-S1422636AbXDCSgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422636AbXDCSgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 14:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422632AbXDCSgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 14:36:39 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:55981 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422631AbXDCSgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 14:36:37 -0400
Date: Tue, 3 Apr 2007 18:56:05 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
Message-ID: <20070403175605.GB1166@gallifrey>
References: <461286D6.2040407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461286D6.2040407@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 18:49:31 up  7:13,  1 user,  load average: 0.36, 0.40, 0.41
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ulrich Drepper (drepper@redhat.com) wrote:

> glibc for a long time provides functionality to retrieve the number
> through sysconf() and this is what fortunately most programs use.  The
> problem is that we are currently using /proc/cpuinfo since this is all
> there was available at that time.  Creating /proc/cpuinfo takes the
> kernel quite a long time, unfortunately (I think Jakub said it is mainly
> the interrupt information).

It's not only expensive to create, it's expensive and annoying to parse;
I don't think it is vaguely consistent accross different architectures
not to mention kernel versions.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
