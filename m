Return-Path: <linux-kernel-owner+w=401wt.eu-S1762889AbYEBHHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762889AbYEBHHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758043AbYEBHGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:06:48 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:25764 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbYEBHGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:06:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lrZdIQ7mfEMroOa3lyVGnpLJoYj7dkDeMeEFR1dApe3dv3xf5jjVZHSFS8zQ+ZzP4YpFFQVu5DPKJIdBi6G45gfc/9YUB0FHoqsM8MwZcmGIXSZkHJUabfJbV/Rg6bErqorpGo4H92pX7o1Bekv7wlQGWXgbSEDWJJdl+s877Lw=
Message-ID: <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com>
Date: Fri, 2 May 2008 00:06:46 -0700
From: "David Rees" <drees76@gmail.com>
To: "Kasper Sandberg" <lkml@metanurb.dk>
Subject: Re: Sharing disks amoung multiple software RAIDs
Cc: "David Lethe" <david@santools.com>, alex14641@yahoo.com,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1209696179.16523.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1209692359.16523.2.camel@localhost>
	 <73000.21239.qm@web50212.mail.re2.yahoo.com>
	 <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com>
	 <1209696179.16523.13.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 7:42 PM, Kasper Sandberg <lkml@metanurb.dk> wrote:
>  in other words, would i be
>  safer to run rsync every day to my other disk, and run in non-raid
>  mode?!

What would be safer is to run rsync every day from one redundant array
to another array - preferably on another machine that is located as
far away as possible from the one that you are backing up.

RAID is not the same as a backup, though unfortunately, too many
people treat it as such.

-Dave
