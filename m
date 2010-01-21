Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277Ab0AUNXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0AUNXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 08:23:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866Ab0AUNXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 08:23:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34569 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0AUNXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 08:23:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GT7s2Kmq9yuWalq2WHFhULtmYya9tpRN1IX7t4jp+KXO7A4UNSjcYDxOW3qn3KNmG9
         sJvuQtsI4YnqtvZh//c24ef+KY/blutl3VEWPDGEPPIjOSr/bmeXLLrKhx9sdcVHH/FT
         7rasViMmF0/7fJmWTW6Sls0sQIgLUE5pDJgdc=
MIME-Version: 1.0
In-Reply-To: <20100121122839.GB26015@nokia.com>
References: <48239d391001210326y25986d59hd10d390ef9c8ddea@mail.gmail.com>
	 <20100121122839.GB26015@nokia.com>
Date: Thu, 21 Jan 2010 16:23:17 +0300
Message-ID: <48239d391001210523l5762775dm8382ad82e7b10e4a@mail.gmail.com>
Subject: Re: MUSB crash on OMAP3 board with second load of gadget
From: Sergey Lapin <slapinid@gmail.com>
To: felipe.balbi@nokia.com
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 3:28 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
> On Thu, Jan 21, 2010 at 12:26:49PM +0100, ext Sergey Lapin wrote:
>>
>> Hi! I have crashes in MUSB code when working with USB gadget drivers.
>> Kernel version: linux-omap master d8ebff302ff819587377b123e900e501e4135d86
>> To reproduce: (USB device cable should be attached).
>>
>> dd if=/dev/zero of=/tmp/disk bs=1k count=1024
>> mkdosfs -F 32 /tmp/disk
>> insmod g_mass_storage  file=/tmp/disk stall=0
>>
>> Wait till disk is mounted on host, then
>>
>> rmmod g_mass_storage
>> insmod g_mass_storage  file=/tmp/disk stall=0
>>
>> And here we get Oops in include/linux/list.h line 93,
>
> I guess it's the list corruption bug, right ?
>
> I've seen that, but couldn't get it to reproduce. Now that you said, I'll
> try to find a fix for it.
It seems so,  thanks a lot!

S.
