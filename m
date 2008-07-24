Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYGYOj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYGYOj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 10:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYGYOjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 10:39:19 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:20982 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYGYOjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 10:39:18 -0400
Subject: RE: HP (Compaq) Smart Array 5xxx controller SCSI driver
From: Andrew Patterson <andrew.patterson@hp.com>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "scameron@beardog.cca.cpqcorp.net" <scameron@beardog.cca.cpqcorp.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778826B3DD7474@GVW0547EXC.americas.hpqcorp.net>
References: <20080722175729.GC8833@beardog.cca.cpqcorp.net>
	 <20080724101953R.fujita.tomonori@lab.ntt.co.jp>
	 <20080724133012.GH8833@beardog.cca.cpqcorp.net>
	 <20080724224438B.fujita.tomonori@lab.ntt.co.jp>
	 <0F5B06BAB751E047AB5C87D1F77A778826B3DD7474@GVW0547EXC.americas.hpqcorp.net>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 13:47:48 -0400
Message-Id: <1216921668.13842.6.camel@boris.fwe.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-24 at 15:00 +0000, Miller, Mike (OS Dev) wrote:
> > > As for the patches I mentioned which were previously ignored for
> > > improving how the current cciss SCSI code handled hot plogging, if
> > > you're curious about that, check here:
> > >
> > > http://marc.info/?l=linux-scsi&m=120213565000426&w=4
> > >
> > > A change like that becomes more important if logical drives are
> > > exposed through the scsi layer.
> >
> > We need to think about the best way to map (expose) logical
> > and physical drivers to SCSI luns. As I wrote before, I'm
> > interested in how HP SCSI driver does.
> 
> We don't neccesarily want or need to expose the physical disks. The
> only exception is disks that are not part of a logical volume. If the
> disks are part of a logical volume but exposed the user may shoot
> themselves in the foot by destroying the firmware metadata.

Exposing the underlying disks can be useful for things such as:

      * Finding out what is in a logical drive.
      * Checking and updating disk firmware.
      * Running smartctrl tests on disks

> -- mikem
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
-- 
Andrew Patterson
Hewlett-Packard

