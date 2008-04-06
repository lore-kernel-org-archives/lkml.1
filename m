Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYDFH0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYDFH0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 03:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYDFH0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 03:26:15 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:56696 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbYDFH0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 03:26:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=w8095c4VS8Z/Dl/OJ6BmgS10V9ptmCrzOfgyOJubC6g6gYnSpJbvgkC4GrckzO8+lroQZoylO9Qaw4fWQbaetif0zljw08ogH2MahVUFFPsi9jkUT16EpcYTMB1F858KvHlv87MRS2EgBJUst6a4VtjZsy1aVwYKp7BTI96Jkcw=
Message-ID: <86802c440804060026o43507775icb4456c0a9f86e07@mail.gmail.com>
Date: Sun, 6 Apr 2008 00:26:12 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Zhao Yakui" <yakui.zhao@intel.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: + acpi-fix-bug-10124.patch added to -mm tree
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Greg KH" <greg@kroah.com>,
       lenb@kernel.org, stian@jordet.net,
       "Linux Kernel ML" <linux-kernel@vger.kernel.org>
In-Reply-To: <1207492303.13675.4.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804032127.m33LRHxl023552@imap1.linux-foundation.org>
	 <20080403233701.GA13357@kroah.com>
	 <20080403170009.baa2b446.akpm@linux-foundation.org>
	 <1207492303.13675.4.camel@yakui_zhao.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 6, 2008 at 7:31 AM, Zhao Yakui <yakui.zhao@intel.com> wrote:
> On Thu, 2008-04-03 at 17:00 -0700, Andrew Morton wrote:
>  > On Thu, 3 Apr 2008 16:37:01 -0700 Greg KH <greg@kroah.com> wrote:
>
> >
>  > > On Thu, Apr 03, 2008 at 02:27:17PM -0700, akpm@linux-foundation.org wrote:
>  > > >
>  > > > The patch titled
>  > > >      acpi: fix bug 10124
>  > > > has been added to the -mm tree.  Its filename is
>  > > >      acpi-fix-bug-10124.patch
>  > > >
>  > > > Before you just go and hit "reply", please:
>  > > >    a) Consider who else should be cc'ed
>  > > >    b) Prefer to cc a suitable mailing list as well
>  > > >    c) Ideally: find the original patch on the mailing list and do a
>  > > >       reply-to-all to that, adding suitable additional cc's
>  > > >
>  > > > *** Remember to use Documentation/SubmitChecklist when testing your code ***
>  > > >
>  > > > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
>  > > > out what to do about this
>  > > >
>  > > > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>  > > >
>  > > > ------------------------------------------------------
>  > > > Subject: acpi: fix bug 10124
>  > > >
>  > > >
>  > > > Unchangelogged patch, taken from
>  > > > http://bugzilla.kernel.org/show_bug.cgi?id=10124
>  > > >
>  > > > Cc: <yakui.zhao@intel.com>
>  > > > Cc: Stian Jordet <stian@jordet.net>
>  > > > Cc: Len Brown <lenb@kernel.org>
>  > > > Cc: Greg KH <greg@kroah.com>
>  > > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>  > >
>  > > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
>  > >
>  > > This should go through Len to Linus for 2.6.25.
>  > >
>  >
>  > That patch was written over a month ago!  Something is wrong here.
>  >
>  > Could someone please write a changelog for it asap?  Then if there's no
>  > fur
>  The patch is out of date. Yinghai Lu sent the updated patch on March
>  4th. But the patch is not merged into the git tree.
>  I will  refresh the patch from the Yinghai Lu and send it again.
>  Thanks.
>  > ther movement I'll merge it this weekend.
>  >

Ingo,

A: - in x86.git/latest
commit 3dab95bd91b6061a887b8a199261c1d92074da85
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Tue Mar 4 11:34:23 2008 -0800

    ACPI: Unneccessary to scan the PCI bus already scanned.

    http://bugzilla.kernel.org/show_bug.cgi?id=10124

is the one Yakui mentioned, but it is after

B: - in x86.git/latest
commit e5491e8eb56d2e4bb0e4a6795bf0662c6703d5ac
Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
Date:   Tue Feb 19 03:20:09 2008 -0800

    x86: get mp_bus_to_node early

C: - in x86.git/latest
commit c0f03f8c4c8dc0aa5fb5d0b791e76f6dff84a288
Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
Date:   Wed Feb 20 12:41:52 2008 -0800

    x86/acpi: make dev_to_node return online node

if the A kind patch is merged to Linus tree via Andrew, we may need
update B and C. to make sure pci/acpi.c is same between
B+C+A with new A + new B + new C

YH
