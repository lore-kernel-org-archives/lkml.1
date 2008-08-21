Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbYHUAVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbYHUAVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 20:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYHUAV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 20:21:28 -0400
Received: from n5.bullet.mail.ac4.yahoo.com ([76.13.13.27]:43746 "HELO
	n5.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751638AbYHUAV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 20:21:27 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 503056.86745.bm@omp124.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=ui0jaqqPPFv/a3cj5DwzO7sFir14F0VmGKh9iB+Kx4/NK3FShNsNSaMKtr9srxnfCx73cflmMGUNsig0yBseWzkKqkSkCOkm18AfYrsDwQJ5iaGW4pm08XXAHwz72LiAEO25vBtDcj12sWNTkZ9KkaMkzMSiNt/M9e71ODRLdRQ=;
X-Mailer: YahooMailWebService/0.7.218
Date: Wed, 20 Aug 2008 17:18:37 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: USB Serial device disconnect causes IRQ disable
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200808202223.57842.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <681979.61508.qm@web45205.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I don't have any driver modules. I have everything built into kernel.
When can this kind of IRQ disable happen, what causes this. The issue happened because of hotplugging my device but the device works fine.
usb_register(driver) might have caused the issue. How do we debug this problem.
Thanks
Amruth p.v


--- On Wed, 8/20/08, Oliver Neukum <oliver@neukum.org> wrote:

> From: Oliver Neukum <oliver@neukum.org>
> Subject: Re: USB Serial device disconnect causes IRQ disable
> To: amruth_pv@yahoo.com
> Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Wednesday, August 20, 2008, 3:23 PM
> Am Mittwoch 20 August 2008 21:34:51 schrieb amruth:
> > Hi
> > I again encountered the same issue IRQ23 disabled.
> > Here is my /proc/interrupts
> 
> There is some unknown interrupt on 23. Try unloading
> drivers until it works. You can sort of bisect it if you
> divide
> your loaded modules in groups.
> 
> 	Regards
> 		Oliver
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


      

