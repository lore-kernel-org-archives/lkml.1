Return-Path: <linux-kernel-owner+w=401wt.eu-S1760628AbXIOLEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760628AbXIOLEF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 07:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbXIOLDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 07:03:55 -0400
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:33117 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbXIOLDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 07:03:55 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Sep 2007 07:03:54 EDT
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Why do so many machines need "noapic"?
Date: Sat, 15 Sep 2007 12:58:27 +0200
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de> <20070915003906.5fa6dc0f.akpm@linux-foundation.org>
In-Reply-To: <20070915003906.5fa6dc0f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709151258.28745.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 September 2007, Andrew Morton wrote:
> There are 48 bugs in bugzilla which mention "noapic"
> 
> http://bugzilla.kernel.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&long_desc_type=substring&long_desc=noapic&kernel_version_type=allwordssubstr&kernel_version=&bug_status=NEW&bug_status=REOPENED&bug_status=ASSIGNED&emailassigned_to1=1&emailtype1=substring&email1=&emailassigned_to2=1&emailreporter2=1&emailcc2=1&emailtype2=substring&email2=&bugidtype=include&bug_id=&chfieldfrom=&chfieldto=Now&chfieldvalue=&regression=both&cmdtype=doit&order=Reuse+same+sort+as+last+time&field0-0-0=noop&type0-0-0=noop&value0-0-0=
> 
> And there are 173,000 on the internet ;)
> http://www.google.com/search?hl=en&q=linux+noapic&btnG=Google+Search
> 
> We screwed this pooch a long time ago - years.  Perhaps if some of the many
> noapic users could run a bisection search to work out when it broke we
> could start fixing things.  But they all have a workaround so there's no
> motivation.

I have 2 SMP-Boards and both need noapic. One is from 2001 (AUSUS CUR-DLS),
one is from June 2006 (Gigabyte M57SLI-S4).

There are many reasons:

1. Bugs which have such a simple workaround don't get much attention.

2. Usually SMP boards are used for machines, which just HAVE to work,
   since they have been expensive. These are not consumer boards.

3. I usually had only USB problems (no IRQ), if ommiting noapic.
   USB technology is a cosumer grade technology and enterprise
   grade developers don't have much interest in it (until now?).

4. IRQ routing setup is often a BIOS issue. You might be able
   to fix that by upgrading your BIOS. That often needs a Windows
   tool. Linux people not always (want to) have access to Windows :-)

I reported the all the problems (starting 2001), no developer 
seemed interested.

I can report them against the latest RC6 kernel tomorrow and put them
into bugzilla, if we now REALLY care.


Best Regards

Ingo Oeser
