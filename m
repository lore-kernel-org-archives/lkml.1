Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbYDVULa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbYDVULa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYDVULW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:11:22 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:29316 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYDVULU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:11:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DBVjniJWLT+nGKWHTZC/5bM0sKlaCAgEJCYrIiCE86tfGTiOPBihGgUVFIWWDFI1rou4cAceTJfu1eQyNBHAM3NnLLcgvS7k+YUg1NYtOnbWow7K/Zw16SAPDd4v+b5T9s8RYkm483UNpZ/6Ye7cwkjIJHaRNTlHdmJ84xHILQA=
Message-ID: <38b2ab8a0804221311u12fd2209l1fe71c99779eb6fa@mail.gmail.com>
Date: Tue, 22 Apr 2008 22:11:13 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Seewer Philippe" <philippe.seewer@bfh.ch>
Subject: Re: Disk geometry from /sys
Cc: "Mark Lord" <lkml@rtr.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <4808A409.3080406@bfh.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
	 <480354C9.1050600@bfh.ch>
	 <38b2ab8a0804150040i14840a9fudc3b95ba80d52ac1@mail.gmail.com>
	 <4805AF93.90209@bfh.ch>
	 <38b2ab8a0804170709m58830adagcba46f059ed10809@mail.gmail.com>
	 <4807635E.9060101@bfh.ch> <4808A09B.6090106@rtr.ca>
	 <4808A409.3080406@bfh.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 3:37 PM, Seewer Philippe <philippe.seewer@bfh.ch> wrote:
>
>  Mark Lord wrote:
>
> > That can sound a bit misleading.  The complete story, for ATA/SATA drives,
> > is that the disk has two geometries:  an internal physical one, with a
> fixed number of heads and cylinders, but variable sectors/track
> > (which normally varies by cylinder zone).
> >
> > Software *never* sees or knows about that geometry, so ignore it.
> >
> > The second geometry, is the one that the drive reports to software
> > as its "native" geometry.  This is what you see from "hdparm -I"
> > and friends, and this geometry is what has to be used by software
> > when using cylinder/head/sector (CHS) addressing for I/O operations.
> > The hardware interface has a limit of 4-bits for the head value,
> > so the maximum number of heads can never be more than 16.
> >
> > Nobody uses CHS addressing for I/O operations, at least not on
> > any hardware newer than at least ten years old, so this geometry
> > is also unimportant for most uses.
> >
> > That's what the drive knows about.
> >
> > Software, for compatibility with the MS-DOS partition table scheme,
> > sometimes uses a "logical" geometry, where we "pretend" that a drive
> > can have up to 255 heads, which then allows more of the disk to be
> > described within the limitations of the partition table data layout.
> > That's where one frequently sees "255 heads", even though the drive
> > underneath uses 16 at the interface level, and probably as only 2
> > or 4 real heads inside the shell.
> >
>
>  Aye. Though I prefer the term virtual geometry. But thats cosmetics. Sorry
> for beeing unclear, and many thanks for untangling my post.
>
>  If anyones interested in even more Details about C/H/S adressing and so on,
> there's a very good document about that to be found here:
>  http://www.mossywell.com/boot-sequence/
>

unfortunately this link doesn't work for now...

-- 
Francis
