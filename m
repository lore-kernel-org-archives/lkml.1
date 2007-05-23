Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbXEWFpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbXEWFpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 01:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbXEWFo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 01:44:56 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:50462 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755120AbXEWFoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 01:44:55 -0400
Message-ID: <4653D4D5.5030504@drzeus.cx>
Date: Wed, 23 May 2007 07:44:53 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
       "Kristian H?gsberg" <krh@bitplanet.net>
Subject: Re: Race free attributes in sysfs
References: <46502A8B.70803@drzeus.cx> <3ae72650705211050p6b6cefbdya70dd4e0a27e2d1b@mail.gmail.com> <4651E866.5010304@drzeus.cx> <1179775695.3320.82.camel@lov.localdomain> <46530F02.7010802@drzeus.cx> <20070523042418.GB27329@kroah.com>
In-Reply-To: <20070523042418.GB27329@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> If you can come up with a wrapper that will work, please let me know and
> I'll be glad to add it.  Right now, it's pretty darn simple to do this
> (look at the USB and PCI core code for examples if you need it.)
>
>   

I guess we have different views on "simple" :)

I had a look at the usb code, which is why I think the current method is
a bit indirect. Right now I instead copied the function that adds the
device attributes given in the bus_type structure. Couldn't that be used
in a more general manner to get device attribute groups?

> Anyway, groups are what you want and need, please use them and then you
> don't have to worry about triggering an event later after you have
> created your files on your own.
>   

I take it I can supply an array of groups somewhere?

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

