Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbYHUGSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbYHUGSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYHUGSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:18:41 -0400
Received: from n5.bullet.mail.ac4.yahoo.com ([76.13.13.27]:23346 "HELO
	n5.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753733AbYHUGSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:18:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 368273.45197.bm@omp106.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=p6zaBIWXN6M1wF/CPhLvgCpx5/mIgbqByk7s0ytjSoM3WNggLJ/0Xt2jY0aL7YkEmiv3DbJvyrqdw+MGzjBXt9QU176xT3tX064n3P9ErwFCA8DY7fz4cfgiSPhLDw3/y88MKzLEpfSNyWTvbqgjulSs6Z5Rsn0WRtAoySHf8ss=;
X-Mailer: YahooMailWebService/0.7.218
Date: Wed, 20 Aug 2008 23:18:38 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: USB Serial device disconnect causes IRQ disable
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200808210809.01517.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <599889.19115.qm@web45210.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, do you have any other USB device on the same bus as
> your serial
> converter?
I have one USB storage flash key device nothing else.
The problem is coming from serial convertor and my driver did not handle interrupts.

Thanks
Amruth p.v


--- On Thu, 8/21/08, Oliver Neukum <oliver@neukum.org> wrote:

> From: Oliver Neukum <oliver@neukum.org>
> Subject: Re: USB Serial device disconnect causes IRQ disable
> To: amruth_pv@yahoo.com
> Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Thursday, August 21, 2008, 1:09 AM
> Am Donnerstag 21 August 2008 08:03:57 schrieb amruth:
> > > What happens when you never plug in the device?
> > Everything works fine without plugging the device. I
> have memory stick 
> > which never creates any problem.
> 
> OK, do you have any other USB device on the same bus as
> your serial
> converter?
> 
> 	Regards
> 		Oliver
> 
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


      

