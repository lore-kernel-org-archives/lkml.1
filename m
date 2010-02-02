Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab0BBTF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 14:05:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:39651 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab0BBTFY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 14:05:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=IXcNShD0iYIjYGu0mdSyHaEhTFYtFYf5tmwKKFjFkd7TRM8pWphx34BWLcFK/aMd2
	TMIQN+dUbjtiX3EI+2WRQ==
MIME-Version: 1.0
In-Reply-To: <4B686B2B.2080406@gmail.com>
References: <4B5885F7.2020007@gmail.com> <4B679EA9.6030203@kernel.org>
	 <4B6833DD.1020001@gmail.com> <4B683581.7070708@kernel.org>
	 <4B683DEF.3000302@gmail.com>
	 <da824cf31002020844r12cada26x57f96b0aa24b59c6@mail.gmail.com>
	 <4B686B2B.2080406@gmail.com>
Date: Tue, 2 Feb 2010 11:04:38 -0800
Message-ID: <da824cf31002021104v72efcd05ne639091042d5999d@mail.gmail.com>
Subject: Re: port multiplier problem
From: Grant Grundler <grundler@google.com>
To: Chandra Shekhar Sah <edu4madh@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 10:12 AM, Chandra Shekhar Sah <edu4madh@gmail.com> wrote:
> Hi Grant,
>
> There are 6 Seagate Barracuda and 6 Hitachi DeskStar.

I thought 0x1095/0x3726 was a Silicon Image part. Can you confirm this?

If it is, this sounds like a broken implementation to me. Here is what
the Silicon Image 3726 Data Sheet says in the introduction:
    Silicon Image’s SiI3726 is 1-to-5 SATA Port Multiplier designed to
provide a high performance link between a single SATA host port and 5
SATA device ports.

So I don't know where the 6th device is getting connected. Some
explanation/data sheet from the HW vendor would be helpful at this
point.

> Seagate Model: ST3750640AS
> Firmware: 3.AAK
>
> Hitachi Model:HDS721075KLA330
> Firmware: Not sure

Both of these drives work behind Sil3726. (First hand experience).

>
> I have attached pictures of both labels, in case.

Perfect - thanks for posting those.

thanks,
grant
