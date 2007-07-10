Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbXGJNOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbXGJNOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbXGJNNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:13:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:32689 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbXGJNNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lHi+u5N3HzkTz3UAacNPRgiqPp1KqoHQTAbrIiOwbpU4D70miEsEhj/WpCwea+0enmsFLe2ftpRGlawupBOEdt6vPFiE9Tx9+bF8m6mUC+nAXP5wsECCrbNJ5uDvp7VDWKpr9y9HSTlJl0P5agZgNP3t0UmUjIYJHhPfCR5yJyE=
Message-ID: <35fbaa3e0707100613r4397bc50h16afe15b89e0bbcb@mail.gmail.com>
Date: Tue, 10 Jul 2007 16:13:51 +0300
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: "Jon Dufresne" <jon.dufresne@infinitevideocorporation.com>
Subject: Re: Driver question: multiple instances of same char device
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1184072796.31808.30.camel@microwave.infinitevideocorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1184072796.31808.30.camel@microwave.infinitevideocorporation.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/07, Jon Dufresne <jon.dufresne@infinitevideocorporation.com> wrote:
> I am relatively new to linux device development. And want to understand
> Linux conventions.
>
> Suppose I have a PCI card that is represented in the system by a
> character device.
>
> If I have two of those PCI cards in the system when the driver module
> loads, is it convention to have two different major numbers, or have one
> major number and two different minor numbers?
>
> Thanks,
> Jon

You can start your kernel hacking way from ldd. It can be found at:
http://lwn.net/Kernel/LDD3/

There are a few other books by R. Love or Greg KH that you can read.

Such questions are fully covered there.

Best,
Vitaliy
