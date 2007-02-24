Return-Path: <linux-kernel-owner+w=401wt.eu-S1750995AbXBXRTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995AbXBXRTi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 12:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbXBXRTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 12:19:38 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:22853 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbXBXRTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 12:19:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pnyv/RocBqqwHn63RbMIIMYq8kFS7ZVO9nZlsAAxfIZ7LWfCTscy4iniXCKcxYsoZCuvNZu58AuZDsrv/DVGlgXokZoZN47MHsEioPYdmAKqD9S39iZH0JP9RM5AhiATvHVRCT5pacwJZwWB06rM5LCmDoWiHZkJ3KrCpoyCXDo=
Message-ID: <8d158e1f0702240919v33182ca2qc0a15fdd27a3f96a@mail.gmail.com>
Date: Sat, 24 Feb 2007 17:19:31 +0000
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Michael-Luke Jones" <jonesml@fastmail.to>
Subject: Re: [QUESTION] Sata RAID
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <6C96CE3D-85F5-479D-BD44-F5DA0AE744FF@fastmail.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702240210x71f981a6xf2fe8917dac5e91a@mail.gmail.com>
	 <200702241624.17024.bzolnier@gmail.com>
	 <6C96CE3D-85F5-479D-BD44-F5DA0AE744FF@fastmail.to>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/07, Michael-Luke Jones <jonesml@fastmail.to> wrote:
> But using 'fakeraid' (i.e. BIOS RAID) together with dmraid is
> generally discouraged in favour of using the more stable and well
> supported Linux Software RAID functionality.
>
> Michael-Luke

I think I actually used dmraid, and the problem I had in those days
was that it was just a layer over your legacy IDE drivers.

With 2.4 you had "real" drivers whom created block devices if I recall
correctly which you could really treat as disks.

If dmraid still works as it did in the days I used it it's just a
layer, like LVM, and the kernel itself doesnt care at all for the
disks being in a RAID set or not and will access the disks
independently, this I really found a reason to not use dmraid and
stick with MD devices.

And by the reactions from you guys I guess those reasons still exist :)

So MD it is,

Thanks!

Patrick
