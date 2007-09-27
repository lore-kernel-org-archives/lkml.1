Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbXI0RUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbXI0RUX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 13:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759017AbXI0RUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 13:20:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50950 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759014AbXI0RUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 13:20:07 -0400
Date: Thu, 27 Sep 2007 10:13:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andy Whitcroft <apw@shadowen.org>, Franck Bui-Huu <vagabon.xyz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: 2.6.23-rc8-mm1 -- powerpc link failure
Message-Id: <20070927101342.92422296.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0709271408170.7567@jikos.suse.cz>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
	<20070925134653.GB8447@shadowen.org>
	<Pine.LNX.4.64.0709251715530.7567@jikos.suse.cz>
	<20070927120308.GJ2213@shadowen.org>
	<Pine.LNX.4.64.0709271408170.7567@jikos.suse.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 14:13:21 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> On Thu, 27 Sep 2007, Andy Whitcroft wrote:
> 
> > Ok, this problem seems to still persist in 2.6.23-rc8-mm2.  It seems we 
> > have three options from here:
> > 1) update the compiler support list to exclude these compilers, or
> > 2) back this change out, or
> > 3) switch to the version not using __weak.
> > The latter seems to be the least intrusive change.  As no-one closer to 
> > the problem is stepping up to make the decision I will propose we go 
> > with the third option here.
> 
> Andrew,
> 
> if you agree with Andy that we should support compilers that don't work 
> with __weak, please drop i386-and-x86_64-randomize-brk.patch and replace 
> it with the one below instead (this has been already posted at 
> http://lkml.org/lkml/2007/8/31/113). Thanks.
> 

We have quite a few instances of __weak in there.  What is special about
this one?

> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> i386 and x86_64: randomize brk()

That's a better patch anyway.  We often use __weak because people
can't be bothered doing all that editing.
