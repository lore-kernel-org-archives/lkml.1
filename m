Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYHGTGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYHGTGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 15:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYHGTFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 15:05:51 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:36763 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbYHGTFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 15:05:50 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Thu, 7 Aug 2008 19:04:54 +0000
Subject: RE: HP (Compaq) Smart Array 5xxx controller SCSI driver
Thread-Topic: HP (Compaq) Smart Array 5xxx controller SCSI driver
Thread-Index: Acjtn7n5SpADQw8aRmqNjeq5vwOnhgLH2D8w
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3F6BF4C@GVW0547EXC.americas.hpqcorp.net>
References: <20080724133012.GH8833@beardog.cca.cpqcorp.net>
	<20080724224438B.fujita.tomonori@lab.ntt.co.jp>
	<0F5B06BAB751E047AB5C87D1F77A778826B3DD7474@GVW0547EXC.americas.hpqcorp.net>
 <20080725000638Q.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080725000638Q.fujita.tomonori@lab.ntt.co.jp>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
> Sent: Thursday, July 24, 2008 10:07 AM
> To: Miller, Mike (OS Dev)
> Cc: fujita.tomonori@lab.ntt.co.jp;
> scameron@beardog.cca.cpqcorp.net;
> linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
> Subject: RE: HP (Compaq) Smart Array 5xxx controller SCSI driver
>
> On Thu, 24 Jul 2008 15:00:00 +0000
> "Miller, Mike (OS Dev)" <Mike.Miller@hp.com> wrote:
>
> >
> > > > As for the patches I mentioned which were previously
> ignored for
> > > > improving how the current cciss SCSI code handled hot
> plogging, if
> > > > you're curious about that, check here:
> > > >
> > > > http://marc.info/?l=linux-scsi&m=120213565000426&w=4
> > > >
> > > > A change like that becomes more important if logical drives are
> > > > exposed through the scsi layer.
> > >
> > > We need to think about the best way to map (expose) logical and
> > > physical drivers to SCSI luns. As I wrote before, I'm
> interested in
> > > how HP SCSI driver does.
> >
> > We don't neccesarily want or need to expose the physical
> disks. The only exception is disks that are not part of a
> logical volume. If the disks are part of a logical volume but
> exposed the user may shoot themselves in the foot by
> destroying the firmware metadata.
>
> Oops, sorry, I meant physical tape drives.
>

Tomo,
I patched your driver into the 2.6.27-rc1 kernel. After compiling the driver I get:

[root@testmonkey linux-2.6]# insmod drivers/scsi/ciss.ko
insmod: error inserting 'drivers/scsi/ciss.ko': -1 Invalid module format

[root@testmonkey linux-2.6]# gcc --version
gcc (GCC) 4.1.2 20071124 (Red Hat 4.1.2-42)

[root@testmonkey linux-2.6]# uname -r
2.6.26

I built inside the tree. Any thoughts?

-- mikem
