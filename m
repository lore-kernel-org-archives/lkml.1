Return-Path: <linux-kernel-owner+w=401wt.eu-S1761315AbZD2Tzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761315AbZD2Tzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZD2Tzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:55:36 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34016 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbZD2Tzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:55:35 -0400
MIME-Version: 1.0
In-Reply-To: <20090429195037.GC1598@khazad-dum.debian.net>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> 
	<20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> 
	<ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> 
	<20090429191841.GA1598@khazad-dum.debian.net> <ac3eb2510904291227v48628c8j181dffc8fdfa1de6@mail.gmail.com> 
	<20090429195037.GC1598@khazad-dum.debian.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 29 Apr 2009 21:55:14 +0200
Message-ID: <ac3eb2510904291255j2aee527bx8e32b356ad0260d1@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 21:50, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Wed, 29 Apr 2009, Kay Sievers wrote:
>> > Debian places it in /var/lib/usbids/ for a good reason.  So does Ubuntu.
>> > Both have working "update-usbids" scripts (might be the one from upstream,
>> > or something different).  They also have the original file in /usr/share, I
>> > don't know if usbutils was changed to check /var first then /usr, or what.
>>
>> Having several files on the same system sounds crazy from a distro
>> standpoint. There needs to be only a single database by default. Users
>
> We are talking about two files, here.  Not several.
>
>> can do whatever they want anyway, but packages should not support such
>> a thing.
>
> If they are to be useful, yes, they do.  Or do you want us to package just
> the usb-ids text file by itself and keep updating it all the time?  That's
> the only other possibility, and it is done for the tzdata.
>
> But update-usbids (like update-pciids and update-intel-microcode) works just
> fine, so likely the usbutils maintainer didn't have any reasons to move from
> update-usbids to a volatile package.
>
>> If the user updates it, what does a new ids file do? Overwrite it
>
> Well, the package overwrites the older one if the download suceeds with a
> mv.  No mess.  If the download fails, the temp file is removed, and the
> older one remains untouched.
>
> There is no mess here.  And it might be a simple case of the package
> creating /var/lib/usbids/usb.ids at post-install time from the static
> packaged data, and usbutils always using just /var/lib/usbids/usb.ids. I am
> not the maintainer of that package, and sincerely, given your tone, I am not
> inclined to go fetch the source and read the scripts.
>
> Now, I am not sure there is any checking against partial downloads.  That is
> one thing a more controlled volatile package would be better at.

And if your distro updates the package, it overwrites the changes you
did to the file, and they are lost?

Kay
