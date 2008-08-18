Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYHROfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYHROfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYHROf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:35:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45341 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbYHROfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:35:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Subject: Re: Warning in during hotplug on 2.6.27-rc2-git5
Date: Mon, 18 Aug 2008 16:38:36 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Greg KH" <greg@kroah.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <200808141753.58547.rjw@sisk.pl> <200808172353.54479.rjw@sisk.pl> <6453C3CB8E2B3646B0D020C112613273C5AC7B@sausexmb4.amd.com>
In-Reply-To: <6453C3CB8E2B3646B0D020C112613273C5AC7B@sausexmb4.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181638.37707.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 18 of August 2008, Langsdorf, Mark wrote:
> > > > The only way I could see that happening if CPU_DEAD/CPU_ONLINE
> > > > is not properly balanced.
> > > 
> > > I'm still seeing it on 2.6.27-rc2, even with the 
> > > patch here http://lkml.org/lkml/2008/7/30/171 and the
> > > wbinvd_halt code patch applied.  Maybe something else
> > > broke in some of the recent hotplug changes?
> > 
> > Mark, have you tried to test with commit 
> > 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0
> > (your "preregister support for powernow-k8" patch) reverted 
> > and MCE enabled?
> 
> Yes, it's a failure on a clean 2.6.27-rc2 installation.

Ah, the commit was done after -rc2, sorry.

I have a couple of questions, then:
- Does it fail identically for all CPUs or for CPU4 and above only?
- Did previous kernels, most importantly 2.6.26, work correctly?

Also, can you please attach dmesg output, including the offlining of a CPU
that would later lead to the problem with cpu_up(), to the Bugzilla entry at
http://bugzilla.kernel.org/show_bug.cgi?id=11337 ?

Thanks,
Rafael
