Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbZD3AqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbZD3AqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZD3Apz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:45:55 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:57864 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZD3Apy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0904291638p398ad701j5dc0f8e96de2fb47@mail.gmail.com>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> 
	<20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> 
	<20090429183012.GA28237@kroah.com> <8bd0f97a0904291638p398ad701j5dc0f8e96de2fb47@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 30 Apr 2009 02:45:33 +0200
Message-ID: <ac3eb2510904291745j48220c12oe2a2b91e981ea403@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 01:38, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Wed, Apr 29, 2009 at 14:30, Greg KH wrote:
>> On Wed, Apr 29, 2009 at 02:17:12PM -0400, Mike Frysinger wrote:
>>> >> find being able to run `usbmodules` pretty useful ... i wrote a script
>>> >> for fun:
>>> >> http://sources.gentoo.org/sys-apps/usbutils/files/usbmodules.sh
>>> >
>>> > Did that work on any 2.6 kernel?
>>>
>>> it's the only version ive tested it with ... but it doesnt parse any
>>> kernel module directly, it reads the generated modules.usbmap file
>>>
>>> > There's no reason we can't add "-k" support to lsusb like lspci has to
>>> > show the modules assigned to different devices.
>>>
>>> the method i posted above only needs the module to be compiled, not loaded
>>
>> As the map files are depreciated, I wouldn't continue to rely on it, it
>> will break in the future when the kernel stops generating those files.
>
> guess i'll have to rewrite it to parse the .ko modules directly like
> the usbmap is generated now

Can't you use the modules.aliases file? That should stay around and
there should be the same information contained.

Kay
