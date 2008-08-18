Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYHRQjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYHRQjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYHRQjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:39:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45858 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbYHRQjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:39:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: Warning in during hotplug on 2.6.27-rc2-git5
Date: Mon, 18 Aug 2008 18:42:24 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Greg KH" <greg@kroah.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <200808141753.58547.rjw@sisk.pl> <200808181638.37707.rjw@sisk.pl> <6453C3CB8E2B3646B0D020C112613273C5AC7D@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC7D@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181842.26099.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of August 2008, Langsdorf, Mark wrote:
> > > > > I'm still seeing it on 2.6.27-rc2, even with the 
> > > > > patch here http://lkml.org/lkml/2008/7/30/171 and the
> > > > > wbinvd_halt code patch applied.  Maybe something else
> > > > > broke in some of the recent hotplug changes?
> >
> > I have a couple of questions, then:
> > - Does it fail identically for all CPUs or for CPU4 and above only?
> > - Did previous kernels, most importantly 2.6.26, work correctly?
> 
> It turns out 2.6.26 also fails.

OK, so I'll drop the bug from the list of recent regressions.

> It is only failing for CPU4+, I'm not sure why that would be significant.

Because I cannot reproduce it on a single-socket AMD quad-core. :-)

> > Also, can you please attach dmesg output, including the 
> > offlining of a CPU that would later lead to the problem
> > with cpu_up(), to the Bugzilla entry at
> > http://bugzilla.kernel.org/show_bug.cgi?id=11337 ?
> 
> I did.

Thanks.  I think we can further debug this using Bugzilla if you don't mind.

Best,
Rafael
