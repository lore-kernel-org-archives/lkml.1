Return-Path: <linux-kernel-owner+w=401wt.eu-S1753407AbYHRNLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbYHRNLv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 09:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752330AbYHRNLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 09:11:43 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:28844 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYHRNLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 09:11:42 -0400
X-BigFish: VPS-28(z21eWz1432R1805Mzzzz2f39iz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K5SSN3-02-SVQ-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Warning in during hotplug on 2.6.27-rc2-git5
Date: Mon, 18 Aug 2008 08:11:32 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC7B@sausexmb4.amd.com>
In-Reply-To: <200808172353.54479.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Warning in during hotplug on 2.6.27-rc2-git5
Thread-Index: AckAs0/xgKMmutoPQoq8h58OG+1TgQAgJDYw
References: <200808141753.58547.rjw@sisk.pl> <20080814163450.GA13814@one.firstfloor.org> <6453C3CB8E2B3646B0D020C112613273C5AC71@sausexmb4.amd.com> <200808172353.54479.rjw@sisk.pl>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Andi Kleen" <andi@firstfloor.org>, <linux-kernel@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 18 Aug 2008 13:11:34.0041 (UTC) FILETIME=[F020C890:01C90133]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The only way I could see that happening if CPU_DEAD/CPU_ONLINE
> > > is not properly balanced.
> > 
> > I'm still seeing it on 2.6.27-rc2, even with the 
> > patch here http://lkml.org/lkml/2008/7/30/171 and the
> > wbinvd_halt code patch applied.  Maybe something else
> > broke in some of the recent hotplug changes?
> 
> Mark, have you tried to test with commit 
> 34ae7f35a21694aa5cb8829dc5142c39d73d6ba0
> (your "preregister support for powernow-k8" patch) reverted 
> and MCE enabled?

Yes, it's a failure on a clean 2.6.27-rc2 installation.

-Mark Langsdorf
Operating System Research Center
AMD

