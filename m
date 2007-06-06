Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbXFFHSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbXFFHSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbXFFHSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:18:03 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:30083 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbXFFHSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:18:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gi8uFRXQOq1gussnQEqa8qnjA6vtpwbqxG8fkESfopiNO/KuVFVRTt/BCmGJbVP3CG2mkZhyO90xy1beQ2xFwcBzh4N/Q+BCRzk44MA5l2p5q0j7LHAXoSOd9/tprWAQDwgCyXt0nYM3ABcoZG0vspcIs0nwOn1FagQhoE5Rx5M=
Message-ID: <a8e1da0706060018p3b7bd79fkd81d12efa3c8c3d6@mail.gmail.com>
Date: Wed, 6 Jun 2007 07:18:00 +0000
From: "dave young" <hidave.darkstar@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [BUG] 2.6.22-rc3-mm1 remove bluetooth usb adapter caused kmalloc bug
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706052211500.7930@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0706051856g242dad96rf4286283192b06c4@mail.gmail.com>
	 <Pine.LNX.4.64.0706052211500.7930@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>2007/6/6, Christoph Lameter <clameter@sgi.com>:
> Note that the corruption seems to have its cause in a decrement done at
> offset 16 into the object pointing to the refcount in struct hci_dev. So
> it looks like the refcount was decremented after the object was freed.
>
> sysfs related?
>

I tested several more times under 2.6.22-rc4, there's  no such problem.

The hci_dev_put is indeed a bug, isn't it? it decrement the refcout on
more time like you said.

But why the slub doesn't warning under 2.6.22-rc4 but do under
2.6.22-rc3-mm1? I'm puzzled.

And if this is a bug , should I write another post to list?  then to
mm or mainline?
I'm still new to kernel list,  thanks you all.

Regards
dave
