Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbZLDS0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbZLDS0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbZLDS0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:26:17 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:46287 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZLDS0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:26:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ae5zXkipVEnSsrDWrgQH9MFpIqDdtohTJDzwlkzfLpxoz3j4tvnQqpx1s6IjW2hJze
         CRoO5yLPmCEZ+cfSoeaZ9CaTBreNFTVRoGgk3CbHucuCDt52Y6NmrRzk/2uBRwzDVcqt
         Y+zOcr9Tu1ufL9GJNzUO66uC1carDEAO5DaAc=
Message-ID: <4B195450.8070409@gmail.com>
Date: Fri, 04 Dec 2009 10:26:24 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Harald Dunkel <harald.dunkel@t-online.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32, hda_codec: kernel gets stuck for 3 minutes at boot time
References: <4B193FDF.3060404@t-online.de>
In-Reply-To: <4B193FDF.3060404@t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/09 08:59, Harald Dunkel wrote:
> Hi folks,
>
> 2.6.32(amd64) gets stuck for about 3 minutes at boot time. dmesg says:
>
> :
> [ 15.026892] HDA Intel 0000:00:08.0: power state changed by ACPI to D0
> [ 15.041001] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 20
> [ 15.054443] HDA Intel 0000:00:08.0: PCI INT A -> Link[LAZA] -> GSI 20
> (level, low) -> IRQ 20
> [ 15.067718] HDA Intel 0000:00:08.0: setting latency timer to 64
> [ 15.424080] hda_codec: ALC662 rev1: BIOS auto-probing.
> [ 190.728138] Adding 1959920k swap on /dev/sda2. Priority:-1 extents:1
> across:1959920k
> [ 191.268572] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01)
> initialised: dm-devel@redhat.com
> :
>
>
> I get the same for 2.6.31.6. I cannot remember having seen this for
> kernel 2.6.29.x.
>
> Hardware is an Acer Aspire Revo R3600. A bios update to the most recent
> version did not help.
>
>
> Any helpful comment or hint would be highly appreciated.
>
>
> Regards
>
> Harri
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>

probably not the same situation as I was experiencing,
but over here I was getting a pause during boot,
long story short it ended up being write_net_rules
in /lib/udev you might try looking in there to see.
(but could be wrong).

Justin P. Mattock
