Return-Path: <linux-kernel-owner+w=401wt.eu-S1760182AbXIOLIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182AbXIOLIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 07:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXIOLI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 07:08:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbXIOLI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 07:08:27 -0400
Date: Sat, 15 Sep 2007 04:08:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: Andi Kleen <andi@firstfloor.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why do so many machines need "noapic"?
Message-Id: <20070915040802.bb3c7093.akpm@linux-foundation.org>
In-Reply-To: <200709151258.28745.ioe-lkml@rameria.de>
References: <46DF3BFF.9000809@redhat.com>
	<p73veao9gih.fsf@bingen.suse.de>
	<20070915003906.5fa6dc0f.akpm@linux-foundation.org>
	<200709151258.28745.ioe-lkml@rameria.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Sep 2007 12:58:27 +0200 Ingo Oeser <ioe-lkml@rameria.de> wrote:

> On Saturday 15 September 2007, Andrew Morton wrote:
> > There are 48 bugs in bugzilla which mention "noapic"
> > 
> > http://bugzilla.kernel.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&long_desc_type=substring&long_desc=noapic&kernel_version_type=allwordssubstr&kernel_version=&bug_status=NEW&bug_status=REOPENED&bug_status=ASSIGNED&emailassigned_to1=1&emailtype1=substring&email1=&emailassigned_to2=1&emailreporter2=1&emailcc2=1&emailtype2=substring&email2=&bugidtype=include&bug_id=&chfieldfrom=&chfieldto=Now&chfieldvalue=&regression=both&cmdtype=doit&order=Reuse+same+sort+as+last+time&field0-0-0=noop&type0-0-0=noop&value0-0-0=
> > 
> > And there are 173,000 on the internet ;)
> > http://www.google.com/search?hl=en&q=linux+noapic&btnG=Google+Search
> > 
> > We screwed this pooch a long time ago - years.  Perhaps if some of the many
> > noapic users could run a bisection search to work out when it broke we
> > could start fixing things.  But they all have a workaround so there's no
> > motivation.
> 
> I have 2 SMP-Boards and both need noapic. One is from 2001 (AUSUS CUR-DLS),
> one is from June 2006 (Gigabyte M57SLI-S4).
> 
> There are many reasons:
> 
> 1. Bugs which have such a simple workaround don't get much attention.
> 
> 2. Usually SMP boards are used for machines, which just HAVE to work,
>    since they have been expensive. These are not consumer boards.
> 
> 3. I usually had only USB problems (no IRQ), if ommiting noapic.
>    USB technology is a cosumer grade technology and enterprise
>    grade developers don't have much interest in it (until now?).
> 
> 4. IRQ routing setup is often a BIOS issue. You might be able
>    to fix that by upgrading your BIOS. That often needs a Windows
>    tool. Linux people not always (want to) have access to Windows :-)
> 
> I reported the all the problems (starting 2001), no developer 
> seemed interested.
> 
> I can report them against the latest RC6 kernel tomorrow and put them
> into bugzilla, if we now REALLY care.
> 

I believe that about two years ago we broke something which caused quite a
large number of people to need noapic.  Is that the case with any of your
machines?  Do you know if they run 2.6.ancient without noapic?

Thanks.

