Return-Path: <linux-kernel-owner+w=401wt.eu-S1751273AbZEJEHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbZEJEHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 00:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750751AbZEJEG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 00:06:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbZEJEG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 00:06:59 -0400
Date: Sat, 9 May 2009 20:58:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: fengguang.wu@intel.com, fweisbec@gmail.com, rostedt@goodmis.org,
       a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       andi@firstfloor.org, mpm@selenic.com, adobriyan@gmail.com,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/8] proc: export more page flags in /proc/kpageflags
Message-Id: <20090509205857.acadb20a.akpm@linux-foundation.org>
In-Reply-To: <20090509104409.GB16138@elte.hu>
References: <20090508105320.316173813@intel.com>
	<20090508111031.020574236@intel.com>
	<20090508114742.GB17129@elte.hu>
	<20090508132452.bafa287a.akpm@linux-foundation.org>
	<20090509104409.GB16138@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009 12:44:09 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 8 May 2009 13:47:42 +0200
> > Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > 
> > > > Export all page flags faithfully in /proc/kpageflags.
> > > 
> > > Ongoing objection and NAK against extended haphazard exporting of 
> > > kernel internals via an ad-hoc ABI via ad-hoc, privatized 
> > > instrumentation that only helps the MM code and nothing else.
> > 
> > You're a year too late.  The pagemap interface is useful.
> 
> My NAK is against the extension of this mistake.
> 
> So is your answer to my NAK in essence:
> 
>  " We merged crappy MM instrumentation a short year ago, too bad.
>    And because it was so crappy to be in /proc we are now also
>    treating it as a hard ABI, not as a debugfs interface - for that 
>    single app that is using it. Furthermore, we are now going to 
>    make the API and ABI even more crappy via patches queued up in 
>    -mm, and we are ignoring NAKs. We are also going to make it even 
>    harder to have sane, generic instrumentation in the upstream 
>    kernel. Deal with it, this is our code and we can mess it up the 
>    way we wish to, it's none of your business."
> 
> right?
> 

If that was my answer, that is what I would have typed.

But I in fact typed something quite different.
