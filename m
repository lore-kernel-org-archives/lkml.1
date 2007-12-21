Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbXLUVE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbXLUVE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbXLUVES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:04:18 -0500
Received: from [76.243.235.52] ([76.243.235.52]:48731 "EHLO
	accolon.hansenpartnership.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753476AbXLUVER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:04:17 -0500
Subject: Re: INITIO scsi driver fails to work properly
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Filippos Papadopoulos <psybases@gmail.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <476C1472.1040103@redhat.com>
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <20071217031841.f483e5ac.akpm@linux-foundation.org>
	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
	 <47666904.8060605@panasas.com>
	 <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
	 <476C1472.1040103@redhat.com>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 15:03:56 -0600
Message-Id: <1198271036.3130.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-21 at 14:30 -0500, Chuck Ebbert wrote:
> On 12/19/2007 03:48 AM, Filippos Papadopoulos wrote:
> > On Dec 17, 2007 2:18 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> >> I have found one problem. Please try patch [2] below and report.
> >> If it still fails try to enable debugging by setting with patch [1]
> >> these values at top of drivers/scsi/initio.c. And send dmsgs.
> >>
> >> Boaz
> >>
> > 
> > 
> > I tried patch[2] (addition of   sg++)  at 2.6.24-rc5-mm1 but the
> > system hangs after some seconds when the initio driver loads.
> > I will try patch[1] next week to see what happens.
> > 
> > Would it be better to open a bug report at bugzilla?
> > 
> 
> There is also a Fedora bug report against 2.6.23. The user has
> applied commit e9e42faf47255274a1ed0b9bf1c46118023ec5fa from
> 2.6.24-rc plus the two additional fixes under discussion and it
> hangs for him too.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=390531

It really sounds like there's some problem applying the patches.  The
consistent report throughout is this one:

initio: I/O port range 0x0 is busy.

Which should be fixed by 99f1f534922a2f2251ba05b14657a1c62882a80e.  I
didn't actually find that in the bug thread anywhere, but maybe I missed
it?

James


> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

