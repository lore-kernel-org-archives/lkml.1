Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbYJUUzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbYJUUzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYJUUzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:55:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:63090 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYJUUze convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=F0V9PS/LJjLuYfe+3Oq4cjMboj9+cpJrZ3+xf3tsEDvnZlAcoe48q3XVxmg4YEkdRl
         0y8iYFiNtixI80cYLye1YaNrxZvAF3IyTCtDlc8LUB825u0WD2lSaBfNU6NomZNmh+b8
         Nh8x54APyctTYVtlsiNfXJ/kVgzTZFSwknt5w=
Message-ID: <2bfaaf400810211355h21bbcddcre50d7c16a5499df3@mail.gmail.com>
Date: Tue, 21 Oct 2008 17:55:32 -0300
From: "Alexandre Lymberopoulos" <lymber@gmail.com>
To: "=?ISO-8859-1?Q?Rog=E9rio_Brito?=" <rbrito@ime.usp.br>
Subject: Re: Bug#502583: scary messages in dmesg
Cc: 502583@bugs.debian.org, 502583-submitter@bugs.debian.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081021101510.GA16244@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2bfaaf400810172145g4aba4827l87a19e67b9742815@mail.gmail.com>
	 <20081018060400.GB916@ime.usp.br>
	 <2bfaaf400810201654u21c9d950o72b2afa9496ba3da@mail.gmail.com>
	 <20081021101510.GA16244@ime.usp.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 7:15 AM, Rogério Brito <rbrito@ime.usp.br> wrote:

> Ok, this far.

Just till that point... ;-)

> Did you sync the device? From the message, it seems that some data were to
> be written to the device, but the device was already gone by that time, but
> I'm not a specialist on the filesystem subsystem and perhaps others could
> say more about it.

No, not that time. I'm used to sync devices via command line, but I
tought that if a device is mounted with sync option tha data is
actually written to the disk when any command to do so is given. I'm
almost convinced that the drive was not in use when I unplugged (I was
rsync'ing mp3 files between devices).

By the way I purged usbmount by now, altought I'm pretty aware that it
may be not safe to unplug the device without unmounting it (which
could be done only logging as root when you use usbmount, since the
device is not in /etc/fstab.)

> In a subsequent mount, I guess.

In a previous one and in the later one.

> Well, it is a bug. It just needs more investigation to see where the bug
> lies.

Not everyone agrees that it'a bug on usbmount, maybe be it's in me... ;-)

I'm not that totally newbie user, so it is good that this happened to
me and not to anyone else...

> Regards, Rogério.

Yours, Alexandre
-- 
===============================================================================
Alexandre Lymberopoulos - lymber@gmail.com
===============================================================================
