Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbXLEMki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbXLEMki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 07:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXLEMka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 07:40:30 -0500
Received: from ro-out-1112.google.com ([72.14.202.178]:35159 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbXLEMk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 07:40:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=aDRECQkYQEcBDwnSe1hlS1ZXlLzWKYl2Ngr1uB2VNe99ekVix1KZRMg7NyQ1tggVOfmKWsDZxAL99gbs0DO+zkxn72lL+RWm8wMBgMuWCq+qoOYZlgd7wwe5DB5Pnc+eJXkjDAxcAmttA1r7E27Z6wYEA4b50vOVDsQMHUMAfXw=
Date: Wed, 5 Dec 2007 20:36:34 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Gabriele Gorla <gorlik@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Patch submission question [not in the FAQ]
Message-ID: <20071205123634.GO2460@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <602863.12913.qm@web53712.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <602863.12913.qm@web53712.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 03:36:54AM -0800, Gabriele Gorla wrote:
>Hello,
>I have submitted a patch for the 3x-xxxx driver on
>alpha several months ago to both the driver maintainer
>and the linux-scsi mailing list.
>I have read all the FAQ and I tried to stick to the
>instructions to the letter.
>However the patch has been completely ignored. No
>reply, no comment, no flames, absolutely nothing...
>
>the original email submission is at the end of the
>email.
>
>could anyone please explain what I am doing wrong?
>
>thanks,
>GG
>
>
>[PATCH 2.6.22] 3w-xxxx: Fix bad unaligned accesses on
>alpha SMP
>
>disable packing of the TAG_TW_Device_Extension
>structure to prevent kernel unaligned accesses when
>accessing ioctl_wqueue.
>Fixes smartmontools kernel panic on alpha SMP
>
>Signed-off-by: Gabriele Gorla <gorlik@yahoo.com>
>---
>
>
>--- linux-2.6.22/drivers/scsi/3w-xxxx.h.orig
>2007-09-01 17:49:22.000000000 -0700
>+++ linux-2.6.22/drivers/scsi/3w-xxxx.h 2007-09-01
>17:49:45.000000000 -0700

It seems that your email client wraps lines.
Please don't do this when you submit patches.


>@@ -392,6 +392,8 @@ typedef struct TAG_TW_Passthru
>        unsigned char padding[12];
> } TW_Passthru;

And also your email clients eats tabs.

Read Documentation/SubmittingPatches, please.
And read Documentation/email-clients.txt to learn more.

Regards.


 Cong

