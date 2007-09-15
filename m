Return-Path: <linux-kernel-owner+w=401wt.eu-S1754264AbXIOHjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbXIOHjh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 03:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbXIOHja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 03:39:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54993 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525AbXIOHj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 03:39:29 -0400
Date: Sat, 15 Sep 2007 00:39:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why do so many machines need "noapic"?
Message-Id: <20070915003906.5fa6dc0f.akpm@linux-foundation.org>
In-Reply-To: <p73veao9gih.fsf@bingen.suse.de>
References: <46DF3BFF.9000809@redhat.com>
	<p73veao9gih.fsf@bingen.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06 Sep 2007 13:31:50 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> Chuck Ebbert <cebbert@redhat.com> writes:
> 
> > Some systems lock up without the noapic option.
> 
> Please find patterns: cpu type, chipsets, mainboard vendors etc.

There are 48 bugs in bugzilla which mention "noapic"

http://bugzilla.kernel.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&long_desc_type=substring&long_desc=noapic&kernel_version_type=allwordssubstr&kernel_version=&bug_status=NEW&bug_status=REOPENED&bug_status=ASSIGNED&emailassigned_to1=1&emailtype1=substring&email1=&emailassigned_to2=1&emailreporter2=1&emailcc2=1&emailtype2=substring&email2=&bugidtype=include&bug_id=&chfieldfrom=&chfieldto=Now&chfieldvalue=&regression=both&cmdtype=doit&order=Reuse+same+sort+as+last+time&field0-0-0=noop&type0-0-0=noop&value0-0-0=

And there are 173,000 on the internet ;)
http://www.google.com/search?hl=en&q=linux+noapic&btnG=Google+Search

We screwed this pooch a long time ago - years.  Perhaps if some of the many
noapic users could run a bisection search to work out when it broke we
could start fixing things.  But they all have a workaround so there's no
motivation.

