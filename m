Return-Path: <linux-kernel-owner+w=401wt.eu-S1422666AbXBAQdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422666AbXBAQdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 11:33:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422669AbXBAQdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 11:33:13 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:12989 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422666AbXBAQdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 11:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tSO/9YddVgt083DRE6OL6BCl9FtX5AWL3zuIJZu3sZf5NpH24b/Yp2lffEg7WLS2dOZbUcEc+AwzkOKTWp7mFlnh0XIUwP9RMxkz/oHg+lYYzY/fAKIwNew4Ey8ptxJL44T7QLRz2Jp0H1zdY9MSyPljMLEFK9L/+JQgXihn6CE=
Message-ID: <80d7e4090702010833u125346f9xc061651c904582f@mail.gmail.com>
Date: Thu, 1 Feb 2007 09:33:10 -0700
From: "Stephen John Smoogen" <smooge@gmail.com>
To: "Brian D. McGrew" <brian@visionpro.com>
Subject: Re: 2.6.16.16 Lost CD-ROM Drive
Cc: jeremy@emperorlinux.com, linux-kernel@vger.kernel.org,
       linux-precision@dell.com
In-Reply-To: <14CFC56C96D8554AA0B8969DB825FEA001C3A234@chicken.machinevisionproducts.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <14CFC56C96D8554AA0B8969DB825FEA001C3A234@chicken.machinevisionproducts.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Brian D. McGrew <brian@visionpro.com> wrote:

> On Thu, 2007-02-01 at 07:00 -0800, Brian D. McGrew wrote:
> > Hey guys-
> >
> > Have a Precision workstation with SATA hard drive and SATA CD-ROM.  If
> I
> > load Fedora Core 5 with a stock 2.6.15 kernel, life is good.
> >
> > However, I need to use 2.6.16.16.  Once I build and install this
> kernel,
> > my CD-ROM drive is gone.  There is a log entry in dmesg that says
> "ATAPI
> > not support.  Ignoring."
> >
> > If I go into the BIOS and set the SATA operations to Legacy/Compatible
> > then everything is fine.  I've rebuilt this kernel about 100 times
> > trying everything I can think of.
> >
> > When I have SATA set to legacy, the HDD and CD are detected as
> /dev/hd*
> > and when they're set to SATA Normal operation the HDD is detected as
> > /dev/sda.  If I boot my old 2.6.15 (stock install) kernel then the CD
> is
> > found as /dev/sdc.
> >
> > I've even tried taking the installation default configuration file for
> > the 2.6.15 kernel and just wholesale copying it into my 2.6.16.16
> kernel
> > and build that way but still no go.
> >
> > What am I missing to get the 2.6.16.16 kernel to see a SATA CD-ROM
> drive
> > in normal, non-legacy move?
>
> Try booting 2.6.16 with the following options:
>
> libata.atapi_enabled=1 ide0=noprobe ide1=noprobe
> -----
>
> Still no go.  /dev/sda* is created for the hard drive but no CD-ROM and
> the same ATAPI error in dmesg.
>


I would try the following:

yum update
and boot the kernel and see what modules are linked to the cdrom. I am
thinking it is the sr_mod module. I would check to see if its compiled
in the 2.6.16 code.




-- 
Stephen J Smoogen. -- CSIRT/Linux System Administrator
How far that little candle throws his beams! So shines a good deed
in a naughty world. = Shakespeare. "The Merchant of Venice"
