Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbZCSWrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbZCSWrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZCSWr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:47:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:32936 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZCSWr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:47:28 -0400
Date: Thu, 19 Mar 2009 23:50:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc5+: usb bluetooth crashes system
Message-ID: <20090319225011.GB6314@elf.ucw.cz>
References: <20090310112307.GD1337@ucw.cz> <20090314034852.GA3417@kroah.com> <20090316114441.GF2405@elf.ucw.cz> <3DA733C2-2755-4D42-9512-7E7110B39526@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3DA733C2-2755-4D42-9512-7E7110B39526@holtmann.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-03-17 10:39:54, Marcel Holtmann wrote:
> Hi Pavel,
>
>>>> Since switch to 2.6.29-rc, bluetooth crashes system... usually on
>>>> disconnect or killall pppd.
>>>
>>> Do we have a trace?
>>
>> We have "bad magic" message, see bugzilla. I guess it is use of
>> spinlock after free?
>
> can you double check with the net-next-2.6 or bluetooth-next-2.6 tree  
> and see if that issue is still present.

Well, I took btusb.c from 2.6.28 and that fixed the issue; so we know
the regression is in btusb.c file between 28 and 29-rc7. If you have
specific version of btusb.c you want me to test, please mail it to me.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
