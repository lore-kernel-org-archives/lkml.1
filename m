Return-Path: <linux-kernel-owner+w=401wt.eu-S1761388AbZD3Byd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761388AbZD3Byd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbZD3ByY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:54:24 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:43378 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbZD3ByX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:54:23 -0400
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0904291848le808891kff973b1677b7cd33@mail.gmail.com>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> 
	<20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> 
	<20090429183012.GA28237@kroah.com> <8bd0f97a0904291638p398ad701j5dc0f8e96de2fb47@mail.gmail.com> 
	<ac3eb2510904291745j48220c12oe2a2b91e981ea403@mail.gmail.com> 
	<8bd0f97a0904291848le808891kff973b1677b7cd33@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 30 Apr 2009 03:54:02 +0200
Message-ID: <ac3eb2510904291854v6f669b80l56f66fb230ae3e2c@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 03:48, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Wed, Apr 29, 2009 at 20:45, Kay Sievers wrote:
>> On Thu, Apr 30, 2009 at 01:38, Mike Frysinger wrote:

>>> guess i'll have to rewrite it to parse the .ko modules directly like
>>> the usbmap is generated now
>>
>> Can't you use the modules.aliases file? That should stay around and
>> there should be the same information contained.
>
> should be fine if it's going to be sticking around
>
> any comments on the attached file ?  in theory, it could be easily
> extended for pci and other busses ...

Hmm, you still use the map files? I meant if you could use:
  /lib/modules/$(uname -r)/modules.alias

The map files are already gone on some distros and will no longer be
around in the future.

Thanks,
Kay
