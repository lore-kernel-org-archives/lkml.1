Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbYFMGft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbYFMGft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 02:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYFMGfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 02:35:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59915 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbYFMGfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 02:35:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <48521539.9020102@s5r6.in-berlin.de>
Date: Fri, 13 Jun 2008 08:35:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Shawn Jin <shawnxjin@gmail.com>
CC: Tomasz Chmielewski <mangoo@wpkg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Force a usb drive to be /dev/sda?
References: <4850DFB4.5020205@wpkg.org> <4851046E.907@s5r6.in-berlin.de> <c3d0340b0806122232s72d37509wd976217d336b83e7@mail.gmail.com>
In-Reply-To: <c3d0340b0806122232s72d37509wd976217d336b83e7@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn Jin wrote:
>>  1. Mount filesystems by UUID or by label.
>>    Doesn't work with some filesystems.
> 
> The bootloader I'm using is LILO. So I have to specify the boot device
> and the root device in lilo.conf. For example, boot=/dev/sda,
> root=/dev/sda1. I'm not sure how mounting filesystem by UUID or by
> label can help. A little bit elaboration will be more helpful.

Ah I forgot that...  Looks like this requires an initrd too, though 
without special scripts of your own.

>>  2. Refer to devices by device ID or by device path.
...
> Every USB thumb drive has a unique ID. So will I have to have a
> different root filesystem image if it's install in a different usb
> drive if the by-id way is adopted?

That's right, hence a filesystem ID is preferable over a drive ID.
-- 
Stefan Richter
-=====-==--- -==- -==-=
http://arcgraph.de/sr/
