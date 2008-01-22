Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYAVWyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYAVWyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbYAVWy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:54:28 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:37024 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbYAVWy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:54:27 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 22 Jan 2008 14:54:25 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Peter Zijlstra <peterz@infradead.org>,
       Denys Fedoryshchenko <denys@visp.net.lb>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc7 to 2.6.24-rc8 possible regression
In-Reply-To: <tkrat.fcd947ba88aa56a8@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0801221453420.15585@alien.or.mcafeemobile.com>
References: <20080121160255.M12670@visp.net.lb>  <47952094.9050102@s5r6.in-berlin.de>
 <20080122110448.M46928@visp.net.lb>  <4796189F.8070506@s5r6.in-berlin.de>
 <1201019283.6341.28.camel@lappy> <tkrat.fcd947ba88aa56a8@s5r6.in-berlin.de>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2008, Stefan Richter wrote:

> (adding Cc: Davide and akpm)
> 
> On 22 Jan, Peter Zijlstra wrote:
> > 
> > On Tue, 2008-01-22 at 17:23 +0100, Stefan Richter wrote:
> >> Denys Fedoryshchenko wrote:
> >> > No, i am using vanilla kernel. It is one of production machines, and as i 
> >> > know screen is not using epoll.
> >> 
> >> OK, but the trace shows that it is the epoll recursion again.
> >> 
> >> > I will try to apply on all my production machines this patch. Sorry if it is 
> >> > related.
> >> 
> >> Well, let's hope that the lockdep annotation or whatever other fix gets
> >> into mainline sooner than later.  Which reminds me to test my setup
> >> again which appeared to be able to reproduce the __wake_up recursion on
> >> my command...
> > 
> > Would be appreciated, I have been waiting on testing feedback because
> > I'm not fully certain here.
> > 
> > Curious though that this gets reported frequently the last few weeks,
> > afaics this problem is way old.
> 
> Here is a report against Fedora's 2.6.23-0.222.rc9.git4.fc8, filed in
> October:  https://bugzilla.redhat.com/show_bug.cgi?id=323411
> 
> I did several tests with a pristine 2.6.24-rc8 now.  The lockdep warning
> below is 100% reliably triggered by grabbing video from a DV camcorder
> with dvgrab v3 via firewire-core's character device file ABI.
> 
> Also, this warning is 100% reliably suppressed by your annotation patch.
> I will reply to this message with this patch for kind consideration by
> those concerned. :-)

Patch? Where is it?



- Davide


