Return-Path: <linux-kernel-owner+w=401wt.eu-S1423012AbXBBAKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423012AbXBBAKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 19:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423024AbXBBAKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 19:10:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:24147 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423012AbXBBAKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 19:10:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cYGK68kvqAE9etnDHFPQJQnMDDq+2/8BNGWu/h4UiKLZaztc9+2QfFUh8J0P6mpaTzaYSaqmq7yLTjbm23bLGnebcW7RD6u79roXiKet1A9upk4SLUISWmJGx9L1gBkOKXoc//IT6O1pdd9YdDHkYvZXAc4IVzKsILIdLR04+7U=
Message-ID: <311601c90702011610t1cb75d67if3c40347f373d7ad@mail.gmail.com>
Date: Thu, 1 Feb 2007 17:10:33 -0700
From: "Eric D. Mudama" <edmudama@gmail.com>
To: TJ <linux@tjworld.net>
Subject: Re: [PATCH 1/1] filesystem: Disk Errors at boot-time caused by probe of partitions
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>,
       "Neil Brown" <neilb@suse.de>
In-Reply-To: <1170373838.30201.45.camel@butch.lan.tjworld.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1170287439.13764.24.camel@butch.lan.tjworld.net>
	 <20070201142648.7d16e4b6.akpm@osdl.org>
	 <1170373838.30201.45.camel@butch.lan.tjworld.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, TJ <linux@tjworld.net> wrote:
> ---- short extract ---
> DC202XX: Primary channel reset.
> ide2: reset: success
> hde: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest
> Error }
> hde: task_in_intr: error=0x04 { DriveStatusError }
> ide: failed opcode was: unknown
> end_request: I/O error, dev hde, sector 238276076
> printk: 8 messages suppressed.
> Buffer I/O error on device hde2, logical block 47279294
> hde: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest
> Error }
> hde: task_in_intr: error=0x04 { DriveStatusError }
> ide: failed opcode was: unknown
> hde: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest
> Error }
...
> The Model number is Maxtor 6Y060L0.

In the log you posted, the drive posted 51/04 to your out-of-bounds
request, but these are 59/04, do they span the end of the device or
something?

I'd be surprised if the drive clunked because of an out of range
command, that model of drive used a very mature interface firmware
with many generations of testing and qualification.
