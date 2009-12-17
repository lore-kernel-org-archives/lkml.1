Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbZLQQJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbZLQQJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759111AbZLQQJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:09:19 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:54702 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759039AbZLQQJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:09:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=H5OMPUrbKh2PCGdA11GOdNWKIecwkT4ZmLbUi7HYeZWY0XlXlTu/bGeIdcF5i32A/f
         m+aKsGu1mc1ZE0v+KaNt2UHowFIFlNNFL4UZHDex2xSRZ6boJldZqQpZu/zyg3UW9I6V
         w/DyRspB1HEF4yEm0sdo0Wv0sdZyyq32n1Z7k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Thu, 17 Dec 2009 17:08:07 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <200912171618.32882.bzolnier@gmail.com> <alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912170726230.17868@localhost.localdomain>
MIME-Version: 1.0
Message-Id: <200912171708.07899.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 December 2009 04:37:41 pm Linus Torvalds wrote:
> 
> On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Examples? :)
> 
> They're typically things like this:
> 
> -			ret = sscanf (buf, "0x%lx - 0x%lx", &start_addr, &end_addr);
> +			ret = sscanf(buf, "0x%lx - 0x%lx", &start_addr,
> +				&end_addr);
> 
> ie a line-break that is just annoying and makes the code harder to read 
> rather than easier. 

Well, it could have been done in the other way:

-			ret = sscanf (buf, "0x%lx - 0x%lx", &start_addr, &end_addr);
+			ret = sscanf(buf, "0x%lx - 0x%lx",
+				     &start_addr, &end_addr);

Just an example that the limit itself is usually not a problem
but its literal interpretation is..

I don't feel strongly about it the either way so how's about just
adding the switch and than changing the default (Alasdair?) on top
of it?

--
Bartlomiej Zolnierkiewicz
