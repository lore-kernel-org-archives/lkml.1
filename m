Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbYH0GVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbYH0GVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 02:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbYH0GVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 02:21:16 -0400
Received: from homer.mvista.com ([63.81.120.158]:12865 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYH0GVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 02:21:16 -0400
From: "Tim Anderson" <tanderson@mvista.com>
To: <dedekind@infradead.org>
Cc: <Bruce_Leonard@selinc.com>, "'Andrew Morton'" <akpm@linux-foundation.org>,
       <linux-mtd-bounces@lists.infradead.org>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
       "'Bruce Leonard'" <brucle@earthlink.net>
Subject: RE: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
Date: Tue, 26 Aug 2008 23:20:46 -0700
Message-ID: <000201c9080d$0bce0d20$6b01a8c0@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1219817017.18027.149.camel@sauron>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Thread-Index: AckIC9NVX3AqwKW3R7i6fFPHbqD8FwAAHnlA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem,

I see your point. Ioctls are going away after all.

So we should have something like:
/sys/class/mtd/mtd0/

Or just under device or platform? 

> -----Original Message-----
> From: Artem Bityutskiy [mailto:dedekind@infradead.org] 
> Sent: Tuesday, August 26, 2008 11:04 PM
> To: Tim Anderson
> Cc: Bruce_Leonard@selinc.com; 'Andrew Morton'; 
> linux-mtd-bounces@lists.infradead.org; 'David Woodhouse'; 
> linux-mtd@lists.infradead.org; linux-kernel@vger.kernel.org; 
> 'Bruce Leonard'
> Subject: RE: [PATCH 2/2][MTD] Add support for > 2GiB MTD devices
> 
> On Tue, 2008-08-26 at 23:01 -0700, Tim Anderson wrote:
> > I have been experimenting with this. I think there is at 
> least 3 maybe 4
> > IOCTLS that are going to need to have a LARGE mode. The 2 
> most obvious are
> > MEMGETINFO and MEMERASE.
> 
> dwmw2 vetoed any MEMGETINFO ioctl changes, or new similar 
> ioctls, and it
> kind of make sense, because we should use sysfs instead. But this, in
> turn, means implementing sysfs support for MTD, because MTD is not
> LinuxDeviceModel-enabled at the moment.
> 
> -- 
> Best regards,
> Artem Bityutskiy (???????? ?????)
> 

