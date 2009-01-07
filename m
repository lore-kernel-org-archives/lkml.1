Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbZAGNmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbZAGNmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:42:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZAGNmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:42:37 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:37802 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZAGNmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:42:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=F77gotio9mZKGuWwZHHOpbzLu02/ZijGQEhZLUzn8cMEcIgHLaeb/LQqQGbnJxuWge
         uJcDFJp4bo3KdCR8XK/yGXroq3byG4zDGHeUhWDFCYnW+ITAdntojE/Jr1LnQrX1MovE
         7YF4wQUp6GYy4RZQxKJ6dsmuvPC1rpTFR4fAI=
Message-ID: <c4e36d110901070542w16eec1b8ve651d1477caa4e32@mail.gmail.com>
Date: Wed, 7 Jan 2009 14:42:35 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: kvm poweroff deadlock
In-Reply-To: <c4e36d110901070254g7f3f3393qef23f3f50322550b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110901060713w28a6e3acq47e91ec53b4b6344@mail.gmail.com>
	 <c4e36d110901070254g7f3f3393qef23f3f50322550b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/7 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
> 2009/1/6 Zdenek Kabelac <zdenek.kabelac@gmail.com>:
>> Hi
>>
>> While testing latest  2.6.29-rc  inside qemu-kvm guest I've got this
>> deadlock while executing poweroff:
>>
>> sd 0:0:0:0: [sda] Stopping disk
>>
>> ACPI: Preparing to enter system sleep state S5
>>
>
> Hi
>
> This might be related to my previous post - but today with
> commit: ede6f5aea054d3fb67c78857f7abdee602302043
>
> I'm getting this oops inside qemu guest while doing poweroff:
>
> ACPI: Preparing to enter system sleep state S5
>
> Disabling non-boot CPUs ...
>
> BUG: unable to handle kernel paging request at 000077ffe1adad5f
>
> IP: [<ffffffff802592d4>] queue_work_on+0x44/0x60
>

My problem seems to be fixed by this patch:


http://marc.info/?l=linux-kernel&m=123131978225429&w=2

Zdenek
