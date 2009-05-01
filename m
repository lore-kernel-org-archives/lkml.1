Return-Path: <linux-kernel-owner+w=401wt.eu-S1759015AbZEALor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759015AbZEALor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758856AbZEALog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:44:36 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:55538 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757624AbZEALof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:44:35 -0400
MIME-Version: 1.0
In-Reply-To: <49FADF20.9050108@msgid.tls.msk.ru>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 
	<20090501061701.GB19234@kroah.com> <20090430234312.a63fa5cf.akpm@linux-foundation.org> 
	<20090501065527.GA19773@kroah.com> <20090501000353.b89caa8c.akpm@linux-foundation.org> 
	<ac3eb2510905010352l661b6671je4cef88096c87878@mail.gmail.com> 
	<49FADF20.9050108@msgid.tls.msk.ru>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 May 2009 13:44:14 +0200
Message-ID: <ac3eb2510905010444x1997a2d3p6a5cbc0cc62bd737@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 13:38, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Kay Sievers wrote:
> []
>>
>> It does not really change anything visible for the normal distros,
>> besides that bootup can be made more efficient by running things in
>> parallel, and that there will be a working and correct /dev in the
>> rescue case.
>
> Ok, how about switch_root done as the last thing in initramfs?
> If there's another filesystem (besides rootfs and real /root)
> mounted, what switch_root (or equivalent) should do?  Or should
> the initramfs script move it (as in mount --move) to /root/dev
> before invoking switch_root?

I thought it should --move it manually. Just instead of mounting its
own tmpfs at /dev, what all common distros do today.

But we can do anything here, that might be more appropriate, if you
have a better idea.

Thanks,
Kay
