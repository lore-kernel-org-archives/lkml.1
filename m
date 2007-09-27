Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbXI0Ver@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbXI0Ver (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbXI0Vek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:34:40 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:22194 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbXI0Vej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:34:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P3TXAWJVpD+J38Cxr5ZJ0J3QCbGcxcgBN25Cn9uvpV+uZ3USLS0sddY4h6VC76sBFn/Wa9Y95uksmBvatZDC6Ekt4wTC9M2g9/qsm6/UD/RtWmqt+VVmwIzW2LgjwNTTjqso1hSklc7DnG/7TUr7ZNO9n12O4MEmbXo47qg9XgQ=
Message-ID: <a6a840cd0709271434j2e637f04pcf6e2c44f162a9fe@mail.gmail.com>
Date: Fri, 28 Sep 2007 00:34:39 +0300
From: "Dmitry Tyschenko" <dtyschenko@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: NO_HZ hangs up AMD MK-36
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <1190927397.23376.147.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a6a840cd0709271328p76ee6a22tf3b60678d6a2d455@mail.gmail.com>
	 <200709272259.26412.rjw@sisk.pl>
	 <a6a840cd0709271401r56d5bebes8e361994ecc5746a@mail.gmail.com>
	 <1190927397.23376.147.camel@chaos>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/9/28, Thomas Gleixner <tglx@linutronix.de>:
> On Fri, 2007-09-28 at 00:01 +0300, Dmitry Tyschenko wrote:
> > Sorry, I am newbie in linux. Hope you was talking about:
> > /boot/vmlinuz-2.6.22-1-k7 root=/dev/sda5 ro nohz=off
>
> Yes.
>
> > But it doesn't help for Debians 2.6.22-1 (I don't have another
> > prebuiled) still same problems.
>
> Can you please add: nolapic_timer instead ?
>
> Thanks,
>
>         tglx

It works with nolapic_timer!
Thank you!
