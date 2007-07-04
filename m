Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbXGDUye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbXGDUye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 16:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbXGDUy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 16:54:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:33791 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbXGDUy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 16:54:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=skAT1f81HrjH1pactXL9NH4+BDEsLaRiLPSIfA77YOdbKGiPfiUd0hDmR3G7lIByITcj5In+7EC+ih8+7qKErf5hhyEenEOmmA5PSo4mMseVysy0INIa6MQNXcQWLYpoSWqfpDwtNVj7FU/SBp4YlOyfUgn0GEA12KAHZfLaosc=
Message-ID: <3ae72650707041354j566ee2caj33aeb70cf87955c4@mail.gmail.com>
Date: Wed, 4 Jul 2007 22:54:25 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Ingo Freund" <linux-kernel-news@e-dict.net>
Subject: Re: md device files missing at boot time
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <468BA187.3080703@e-dict.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <468BA187.3080703@e-dict.net>
X-Google-Sender-Auth: 93b8778ea7aba031
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/4/07, Ingo Freund <linux-kernel-news@e-dict.net> wrote:
> one of the systems I'm working with was changed (copied) from single (scsi - sda1)
> to multiple disk (raid1) (sdb1,sdc1 --> md0).
> When I try to boot from the new created md-device it stops with:
> ...
> loading reiserfs
> "Waiting for device /dev/md0 to appear: ........ not found -- Exiting to /bin/sh
>
> # ls -la /dev/md*
> shows nothing, so I understand why the "/" cannot be mounted, but
> where are the /dev/md* files (I found them in "/lib/udev/devices")?
>
> The kernel is vanilla 2.6.21.5, the (I think) needed hardware and filesystem
> drivers are built in modules and put into an initrd file for loading at boot time.
>
> Does anyone have an idea what I might do wrong?

How did you build the initramfs image? /sbin/mkinitrd?

Did you add md support to the image?

Kay
