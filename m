Return-Path: <linux-kernel-owner+w=401wt.eu-S1760718AbYDVUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbYDVUQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYDVUQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:16:04 -0400
Received: from rv-out-0708.google.com ([209.85.198.247]:13008 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751383AbYDVUQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d1BX/Fl2PFLKLBKyGqnYpoVyTimW9fc8N9RGV1XyEWH2kKcar9xwdpPE5x1iEwhVk/UZ3GBzqm6Myv4Otlojz+tsQQUbDHo4TYxQJeuVvZUFEx5sdI2q9XtwarIfqK8vRIxcvDnTF9rC9ycXCYu7F9EFpwwtrQfgogNbH51M4cc=
Message-ID: <38b2ab8a0804221316o7cab5641q16814849a1099b9a@mail.gmail.com>
Date: Tue, 22 Apr 2008 22:16:01 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: Disk geometry from /sys
Cc: "Seewer Philippe" <philippe.seewer@bfh.ch>, linux-kernel@vger.kernel.org
In-Reply-To: <4808A09B.6090106@rtr.ca>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark

On Fri, Apr 18, 2008 at 3:22 PM, Mark Lord <lkml@rtr.ca> wrote:
>  That can sound a bit misleading.  The complete story, for ATA/SATA drives,
>  is that the disk has two geometries:  an internal physical one, with a
> fixed number of heads and cylinders, but variable sectors/track
>  (which normally varies by cylinder zone).
>
>  Software *never* sees or knows about that geometry, so ignore it.
>
>  The second geometry, is the one that the drive reports to software
>  as its "native" geometry.  This is what you see from "hdparm -I"
>  and friends, and this geometry is what has to be used by software
>  when using cylinder/head/sector (CHS) addressing for I/O operations.
>  The hardware interface has a limit of 4-bits for the head value,
>  so the maximum number of heads can never be more than 16.
>
>  Nobody uses CHS addressing for I/O operations, at least not on
>  any hardware newer than at least ten years old, so this geometry
>  is also unimportant for most uses.
>

Is it because IDE drives support several IO operation modes ?

thanks
-- 
Francis
