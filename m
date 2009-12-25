Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbZLYBWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbZLYBWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 20:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbZLYBWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 20:22:13 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:45611 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbZLYBWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 20:22:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jsrl7Nl895XhiGw+38YX4zSUrkwyHQ+tihz7IQiSvaX7x3EEHP1BkCKoa3iy5DCUMQ
         TSiuoMdl464xGGrWqpYgShBCuSHG+W8kk3nLf3D19Y+eqa5awNBSozp6Q7Yuiw/Ziuei
         f8aykpVFrvzEnRH8TIUHrccf7gA3hDKfgk03g=
Message-ID: <4B3413C4.6070602@gmail.com>
Date: Thu, 24 Dec 2009 17:22:12 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Sedat Dilek <sedat.dilek@googlemail.com>
CC: LKML <linux-kernel@vger.kernel.org>, len.brown@intel.com
Subject: Re: [2.6.33-rc2] ACPI problems on HP nc6400 notebook
References: <2d0a357f0912241711o97011od6c1750d7acf8b9e@mail.gmail.com>
In-Reply-To: <2d0a357f0912241711o97011od6c1750d7acf8b9e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/09 17:11, Sedat Dilek wrote:
> Hi,
>
> I build linux-2.6.33-rc2 on a Debian/sid 32-bit host.
> Unfortunately, this kernel falls in an unusable state (sort of loop)
> and does not a normal startup.
>
> With this setting (see below), I hoped to catch the early
> boot-messages (but, no success):
>
> # cat /etc/default/bootlogd
> # Run bootlogd at startup ?
> BOOTLOGD_ENABLE=Yes
>
> Finally, I could take a picture [1].
> It seems to be that latest ACPI patches are breaking my system (speculating).
>
> Q: How can I log such early boot (error) messages to give a detailled log?
>
> Hope this helps fixing the problem.
>
> Kind Regards,
> - Sedat -
>
>
> [1] http://files.iniza.org/linux-kernel/DSCN2134.JPG
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

you can try(if you have the port)
ohci1394_dma=early or the usb
early logging located in kernel hacking.

but if this thing is hitting way early it
might be a bit more tricky.

if you can try  a bisect from the bad
kernel to the good.

Justin P. Mattock
