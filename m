Return-Path: <linux-kernel-owner+w=401wt.eu-S1753708AbZJQU6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbZJQU6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 16:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZJQU6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 16:58:51 -0400
Received: from imp01.mtu.ru ([62.5.255.10]:59306 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbZJQU6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 16:58:50 -0400
Message-ID: <4ADA3136.1090802@aknet.ru>
Date: Sun, 18 Oct 2009 01:03:50 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] fix driver_register() return value
References: <4ADA29AA.9070907@aknet.ru> <20091017204608.GA5676@suse.de>
In-Reply-To: <20091017204608.GA5676@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

18.10.2009 00:46, Greg KH wrote:
>> Returning -EBUSY fixes the problem.
>> Signed-off-by: Stas Sergeev<stsp@aknet.ru>
> Does this cause problems with the way things now are?  If so, what are
> they?
They are simple.
Suppose the pcspkr driver was loaded
by the udev. Then someone types:
modprobe snd-pcsp
and that doesn't print anything, so
he thinks the snd-pcsp was loaded and
asks me why there is no sound. :)
Only by typing "dmesg" you can see what
actually happened, but it would be better
to have that from modprobe too.

> Does this change need to be backported to older -stable kernels?
I think it can't hurt.
