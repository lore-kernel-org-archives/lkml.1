Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023Ab0AGUOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab0AGUOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196Ab0AGUOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:14:08 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:32312 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0AGUOD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:14:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=YUD9+LaKGDDgeyFND82q02V3OrEvFe0rKCOekSjnnFrUU+p71JRQjSVniQ4WJwZF14
         BpG5oKd40J16qrCQxrnlvkCQrb0qKi5qfYJvJHgPBFRrC47fnsWRZ45DBq0l+gTESPhe
         GBBOgGJarDes5BxvdloUIrJW0UqbIOuzeHDgE=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <8db1092f1001071136o20ac7e19nb102c7afde8c21e7@mail.gmail.com>
References: <8db1092f1001071136o20ac7e19nb102c7afde8c21e7@mail.gmail.com>
Date: Thu, 7 Jan 2010 21:14:01 +0100
Message-ID: <2d0a357f1001071214m6780def8md80c056161d0aa79@mail.gmail.com>
Subject: Re: [2.6.33-rc3] [WMI?] [RFKILL?] [WIRELESS?] hang: BUG: Unable to 
	handle kernel NULL pointer dereference at 00000008
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       carlos@strangeworlds.co.uk,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>, ilw@linux.intel.com,
       len.brown@intel.com, Anisse Astier <anisse@astier.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

seems like the ACPI/hp-wmi bug, nothing to do with linux-wireless.

I have already reported this bug (again) [1] and unfortunately it has
re-entered upstream.
A single new patch was sent by Anisse [2].
This patch is waiting in linux-acpi-2.6/test [3].

Don't ask me why it has not been included in 2.6.33-rc3.
For some HP-notebook users it is a CRITICAL bug.

Kind Regards,
- Sedat -

[1] http://marc.info/?t=126227644600001&r=1&w=2
[2] http://marc.info/?t=126215864800004&r=1&w=2
[3] http://git.kernel.org/?p=linux/kernel/git/lenb/linux-acpi-2.6.git;a=commit;h=c9c041fcb1a4d69ed4791f00b57554eeb341d148

On Thu, Jan 7, 2010 at 8:36 PM, Maciej Rutecki <maciej.rutecki@gmail.com> wrote:
> Last known good: 2.6.33-rc2
> Affected: 2.6.33-rc3
>
> Description:
>
> 1. When wireless button enabled system hangs on:
> http://unixy.pl/maciek/download/kernel/2.6.33-rc3/DSC_0038.JPG
>
> 2. When disable bluetooth and wireless button, I got a bug:
> http://unixy.pl/maciek/download/kernel/2.6.33-rc3/DSC_0039.JPG
>
> 3. When reboot I have message:
> http://unixy.pl/maciek/download/kernel/2.6.33-rc3/DSC_0040.JPG
>
> Config:
> http://unixy.pl/maciek/download/kernel/2.6.33-rc3/config-2.6.33-rc3
>
> Regards
>
> --
> Maciej Rutecki
> http://www.maciek.unixy.pl
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
