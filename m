Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYGXPBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYGXPBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYGXPAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:00:52 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:5770 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYGXPAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:00:51 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Thu, 24 Jul 2008 15:00:00 +0000
Subject: RE: HP (Compaq) Smart Array 5xxx controller SCSI driver
Thread-Topic: HP (Compaq) Smart Array 5xxx controller SCSI driver
Thread-Index: Acjtk/4nB7hhZd7qRYaRtd5SFhRjzAACYr3w
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3DD7474@GVW0547EXC.americas.hpqcorp.net>
References: <20080722175729.GC8833@beardog.cca.cpqcorp.net>
	<20080724101953R.fujita.tomonori@lab.ntt.co.jp>
	<20080724133012.GH8833@beardog.cca.cpqcorp.net>
 <20080724224438B.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080724224438B.fujita.tomonori@lab.ntt.co.jp>
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


> > As for the patches I mentioned which were previously ignored for
> > improving how the current cciss SCSI code handled hot plogging, if
> > you're curious about that, check here:
> >
> > http://marc.info/?l=linux-scsi&m=120213565000426&w=4
> >
> > A change like that becomes more important if logical drives are
> > exposed through the scsi layer.
>
> We need to think about the best way to map (expose) logical
> and physical drivers to SCSI luns. As I wrote before, I'm
> interested in how HP SCSI driver does.

We don't neccesarily want or need to expose the physical disks. The only exception is disks that are not part of a logical volume. If the disks are part of a logical volume but exposed the user may shoot themselves in the foot by destroying the firmware metadata.

-- mikem
