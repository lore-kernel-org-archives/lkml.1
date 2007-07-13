Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbXGMKPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbXGMKPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 06:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753650AbXGMKO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 06:14:59 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:13132 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbXGMKO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 06:14:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lAxEAZo4DOtKuZ5O0+JnfGRCsaIXSZde+WBoLFqX6hhP9rOys4Tz3bipZdawSk4/bIDvSCfqwqn0KKABfSSajfyTRmO5hNGv5ktFuD+7S9neA4lKPtWm3kpKhz166lmviQrH9J0ufAUDfzZtmqN1ZxNBimrkica/v7hJnZzUKGs=
Message-ID: <ffe84fe30707130314y71434167u54d30feabda8ed36@mail.gmail.com>
Date: Fri, 13 Jul 2007 18:14:57 +0800
From: "Eden Chen" <eden.s16@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] [PATCH] USB: driver for CM109 chipset
In-Reply-To: <ffe84fe30707130312u584d8fddhbf4ddc9bbcac553d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ffe84fe30707130312u584d8fddhbf4ddc9bbcac553d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I have a question about CM109 USB VoIP device.
Hope someone could told me how to treat it, many thanks first.

There are two CM109 chip VoIP phone device from different hardware vendor,
and they have the same vid/pid(0x0d8c/0x000e).
Now, here is the problem that key definition is different on them.
key matrix mapping is not the same between KomuniKate KIP1000
and Goodway AA2650.
How does the cm109.c distinguish two cm109 chip device except vid/pid?

Goodway AA2650 USB Phone
http://www.goodway.com.tw/en/product3.asp?id=6&subid=37&pid=517&typeid=

KIP1000
http://www.komunikate.eu.com/kip1000.php

On windows, most vendor ship their VoIP device with CD
that include key configuration utility.
So end user can easy set every key of VoIP device.

On Linux, should we create a VoIP driver interface to userland for
anyone wants to customize key definition? Then the CM109 driver can
focus report transmission on HID device. But this kind of interface
seems only hiddev interface supported, right?
