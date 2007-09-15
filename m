Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbXIOSbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbXIOSbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 14:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbXIOSaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 14:30:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49300 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101AbXIOSav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 14:30:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Why do so many machines need "noapic"?
Date: Sat, 15 Sep 2007 20:42:48 +0200
User-Agent: KMail/1.9.5
Cc: Andi Kleen <andi@firstfloor.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46DF3BFF.9000809@redhat.com> <p73veao9gih.fsf@bingen.suse.de> <20070915003906.5fa6dc0f.akpm@linux-foundation.org>
In-Reply-To: <20070915003906.5fa6dc0f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709152042.48901.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 15 September 2007 09:39, Andrew Morton wrote:
> On 06 Sep 2007 13:31:50 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Chuck Ebbert <cebbert@redhat.com> writes:
> > 
> > > Some systems lock up without the noapic option.
> > 
> > Please find patterns: cpu type, chipsets, mainboard vendors etc.
> 
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

Well, I think it broke soon after 2.6.9.

Please see http://bugzilla.kernel.org/show_bug.cgi?id=3639#c10
