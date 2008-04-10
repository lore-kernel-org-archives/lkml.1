Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbYDJTGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbYDJTGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYDJTFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:05:54 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:59160 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYDJTFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IHFVUQUxo0HGIPKWJQD1WsdqUUCnsjrSaUkfKp7x0jo5oq5FrlGiyAM+t/WKCUcw/U9lURrAWfsiaiWVFVrmYGcUNdeewB+Aa2XLlxNHFzrjAxOX/Ys+3n7B9Gyv//DIy5Qis9r2IMUx1A7gW2uKBgnEKNXnSSR5n6k0eJ9+bk4=
Message-ID: <38b2ab8a0804101205s1e0e4fa0l884286ec7ea9ccbd@mail.gmail.com>
Date: Thu, 10 Apr 2008 21:05:50 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: Disk geometry from /sys
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47FD3BBB.406@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
	 <47FD3BBB.406@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Apr 9, 2008 at 11:57 PM, Mark Lord <lkml@rtr.ca> wrote:
> > I'm trying to know the geometry of my hard disk from a bash script
> > and that's the reason I'm looking in /sys. The reason is that I'd like
> > to figure out the size of a cylinder without doing a
> > ioctl(bdev, HDIO_GETGEO, &geo)
> >
>
>  $ DEV=/dev/sda
>  $ GEOM="`/sbin/hdparm -g $DEV | awk '{print $3}'`"
>  $ echo $GEOM
>  19457/255/63
>  $
>

Sure and you could the same with fdisk, sfdisk, parted outputs...

But that wasn't my point, sorry if it wasn't clear.

I was actually wondering why /sys/block/sda exports a lot of disk
features but the disk geometry. I was wondering if somthing like

/sys/block/sda/geometry/heads

could be useful...

-- 
Francis
