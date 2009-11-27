Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZK0MDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZK0MDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZK0MDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:03:51 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:43979 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbZK0MDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:03:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=fiktaLtiLfdCyANpA/bRtUH/syVPM6uXOyrOuDTwen1OOUlCShPeCWvyYh19JLm5jB
         QXaDHTxrNwiEm377+wja24JVuKM07Wj5/yVA/eM70KlwZ/8gZ+OOIkcMtmlw/bCcuMp8
         MGddsy5Y3LIYfGflSBGIrMHuR9VBytrz7D3to=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.0911271158560.3659@twin.jikos.cz>
References: <39840bc80911241957r38e6f26ah437f73fc890236c0@mail.gmail.com>
	 <alpine.LRH.2.00.0911271158560.3659@twin.jikos.cz>
Date: Fri, 27 Nov 2009 14:03:55 +0200
X-Google-Sender-Auth: 4551400f54edd1c1
Message-ID: <39840bc80911270403q83c16efy872cc1f72a0344ee@mail.gmail.com>
Subject: Re: touchscreen wirh 2.6.26
From: Alex Custov <alex.custov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/27 Jiri Kosina <jkosina@suse.cz>:
> On Wed, 25 Nov 2009, Alex Custov wrote:
>
>> I have Acer T230H on Debian Lenny with 2.6.26.8 manually complied
>> kernel. The problem is that this is a multitouch monitor and it seems
>> that it doesn't work at all (even single touches). All things under
>> "Drivers => Input device support => Touchscreens" are enabled in kernel
>> (as modules). Is this type of monitor supported, or I should upgrade to
>> a newer kernel? Thanks.
>
> How is the touchscreen conntected to system? Is it USB? If so, what is the
> vendor and product ID? (lsusb will tell).
>
> --
> Jiri Kosina
> SUSE Labs, Novell Inc.
>
>

Hi. Thanks for answer. I've already found the /dev device it has - it
is /dev/usb/hiddev0. Yes, it is USB connected. I did "cat
/dev/usb/hiddev0" and touched some points on the screen, it seems that
it works (I got some binary data from 'cat'). Now I will try to add
the corresponding section to the xorg.conf to let it work in X.

--
