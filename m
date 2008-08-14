Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbYHNSgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbYHNSgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbYHNSf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:35:58 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:5083 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYHNSf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:35:57 -0400
X-BigFish: VPS-47(z21eWz1432R98dR1805M936fQzzzz2f39iz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K5LSZG-02-WKV-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Warning in during hotplug on 2.6.27-rc2-git5
Date: Thu, 14 Aug 2008 13:35:49 -0500
Message-ID: <6453C3CB8E2B3646B0D020C112613273C5AC71@sausexmb4.amd.com>
In-Reply-To: <20080814163450.GA13814@one.firstfloor.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Warning in during hotplug on 2.6.27-rc2-git5
Thread-Index: Acj+K4h6wtKlXqTpSICWyoScChZazAAELIoA
References: <200808141753.58547.rjw@sisk.pl> <20080814163450.GA13814@one.firstfloor.org>
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: "Andi Kleen" <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 14 Aug 2008 18:35:50.0163 (UTC) FILETIME=[933A6630:01C8FE3C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Aug 14, 2008 at 05:53:57PM +0200, Rafael J. Wysocki wrote:
> > On Wednesday, 13 of August 2008, Mark Langsdorf wrote:
> > > I'm seeing the following error message when I hotunplug and replug
> > > a cpu in 2.6.27-rc2-git5.  The system becomes unstable almost
> > > immediately afterwards.
> > 
> > Hm, it seems that MCE is involved somehow.  Andi, can you 
> have a look at this,
> > please?
> 
> FWIW the mce code here actually hasn't changed for a long time.
> 
> 
> > > ------------[ cut here ]------------
> > > WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x33/0x39()
> > > sysfs: duplicate filename 'machinecheck4' can not be created
> 
> The only way I could see that happening if CPU_DEAD/CPU_ONLINE
> is not properly balanced.

I'm still seeing it on 2.6.27-rc2, even with the 
patch here http://lkml.org/lkml/2008/7/30/171 and the
wbinvd_halt code patch applied.  Maybe something else
broke in some of the recent hotplug changes?

-Mark Langsdorf
Operating System Research Center
AMD

