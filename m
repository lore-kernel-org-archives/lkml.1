Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbZD2T2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbZD2T2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbZD2T2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:28:21 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:44371 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbZD2T2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <20090429191841.GA1598@khazad-dum.debian.net>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> 
	<20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> 
	<ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> 
	<20090429191841.GA1598@khazad-dum.debian.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 29 Apr 2009 21:27:59 +0200
Message-ID: <ac3eb2510904291227v48628c8j181dffc8fdfa1de6@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 21:18, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Wed, 29 Apr 2009, Kay Sievers wrote:
>> >>> looks like update-usbids.sh was forgotten from EXTRA_DIST in
>> >>> Makefile.am so the released tarball doesnt have the script ;(
>>
>> > np, i'll send patches for both
>>
>> Ah missed that, sorry. Sounds good if you add it to the tarball, but
>> please don't add it to "make install", as packages should not ship
>> scripts which change the installed package content, unless it's a
>> config file.
>
> Debian places it in /var/lib/usbids/ for a good reason.  So does Ubuntu.
> Both have working "update-usbids" scripts (might be the one from upstream,
> or something different).  They also have the original file in /usr/share, I
> don't know if usbutils was changed to check /var first then /usr, or what.

Having several files on the same system sounds crazy from a distro
standpoint. There needs to be only a single database by default. Users
can do whatever they want anyway, but packages should not support such
a thing.

If the user updates it, what does a new ids file do? Overwrite it
unconditionally? Keep the old outdated hanging around, and lsusb does
not pick the new one up? That sounds like total a mess.

Thanks,
Kay
