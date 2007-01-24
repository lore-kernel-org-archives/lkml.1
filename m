Return-Path: <linux-kernel-owner+w=401wt.eu-S964785AbXAXXcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785AbXAXXcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 18:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964786AbXAXXcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 18:32:53 -0500
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:11405 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964785AbXAXXcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 18:32:52 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.0.6487.1
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] scsi: use lock per host instead of per device for shared queue tag host
Date: Wed, 24 Jan 2007 15:33:57 -0800
Message-ID: <B70A50D07063384EB9BCE3330D18414F02F5AF83@nonameb.ptu.promise.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] scsi: use lock per host instead of per device for shared queue tag host
Thread-Index: Acc/0NITAs4XtQHaRmmJlX3mWPtIrwAO+99Q
From: "Ed Lin" <ed.lin@promise.com>
To: "Michael Reed" <mdr@sgi.com>
Cc: "linux-scsi" <linux-scsi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "james.Bottomley" <james.Bottomley@SteelEye.com>,
       "jeff" <jeff@garzik.org>, "Promise_Linux" <Promise_Linux@promise.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Michael Reed [mailto:mdr@sgi.com] 
> Sent: Wednesday, January 24, 2007 7:59 AM
> To: Ed Lin
> Cc: linux-scsi; linux-kernel; james.Bottomley; jeff; Promise_Linux
> Subject: Re: [patch] scsi: use lock per host instead of per 
> device for shared queue tag host
> 
> 
> How 'bout a comment in scsh_host.h indicating that the 
> pointer will be NULL unless
> initialized by the driver?
> 
> "Protect shared block queue tag" is unique to stex.  Perhaps 
> have no comment on
> the variable declaration in scsi_host.h and explain why you 
> use it in stex.
> 
> Mike
> 
> 

Thanks for commenting. I agree more detailed explaination should
be better.

It seems another driver(qla4xxx) is also using shared queue tag.
It is natural to imagine there might be same symptom in that
driver. But I don't know the driver and have no hardware so I
can not say anything certain about it.

Ed Lin
