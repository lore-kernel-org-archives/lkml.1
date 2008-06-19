Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbYFSXNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbYFSXNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 19:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbYFSXNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 19:13:35 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:29862 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753346AbYFSXNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 19:13:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wUQMHhvDjYgW+rI/S3D7Ys8lvClSdF71n6cx8Hu88o/q90nNAp6z3ZEfZVH4eyRc1Ku9d/9oRF1m9e6hmUSDaLQhNPvbvjyxJQsSTQLu2L3JH+4PVWlxUKWrqv6s0LyF8JoEsDhBMe4s8OODfMaRgY1FgiaKXUv92GfokrjQezU=  ;
X-YMail-OSG: GKxXwRwVM1m3acdYYRnjtBg16V6ZswvJvfdJxp3dosEvdzpYSbRsPym6VlqR70WSrSfyAA9m7YsXefnVnfYVTV4TszrCGCcuV7_yk.SgOA1m4nF9jT7SjGfTza3bttQmwZE-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Date: Thu, 19 Jun 2008 16:13:25 -0700
User-Agent: KMail/1.9.9
Cc: Matthew Wilcox <matthew@wil.cx>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, dsd@gentoo.org,
       mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org,
       vegardno@ifi.uio.no, James.Bottomley@hansenpartnership.com,
       linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>
References: <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200806191613.25552.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 June 2008, Alan Stern wrote:
> Maybe a better approach would be to poll at reasonable intervals 
> (HZ/10, for example) for the existence of the root device.  If it 
> hasn't appeared after some reasonable time (30 seconds?) then give up.

Why give up, ever? 

If someone has to walk across the room to grab the device with the
root filesystem, then has to answer the phone, then deal with the
next interruption ... for an hour before getting back to the machine
they rebooted, why shouldn't it just work to plug in the USB flash
drive (CF card, MMC card, or whatever) *THEN* instead of having had
to rush and meet some arbitrarily early deadline?

When there's no root, I don't see how waiting for it to arrive
could be a lose...

- Dave

