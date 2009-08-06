Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbZHFRPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbZHFRPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756264AbZHFRPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:15:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:41748 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbZHFRPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:15:30 -0400
MIME-Version: 1.0
In-Reply-To: <200908062006.16263.a1426z@gawab.com>
References: <20090805171513.GA10443@kroah.com> <20090805185136.GA21442@kroah.com> 
	<87ljlxhrnr.fsf@basil.nowhere.org> <200908062006.16263.a1426z@gawab.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 6 Aug 2009 19:15:15 +0200
Message-ID: <ac3eb2510908061015p1c7fd544hc8d8e5bdac738c08@mail.gmail.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based 
	/dev
To: Al Boldi <a1426z@gawab.com>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 19:06, Al Boldi<a1426z@gawab.com> wrote:
> Andi Kleen wrote:
>> Greg KH <greg@kroah.com> writes:
>> > It makes the userspace boot process much simpler and easier to maintain,
>> > as well as providing a way to handle rescue disks and images trivially,
>> > and it makes the kernel _less_ dependant on the early userspace bootup
>> > scripts.
>>
>> As a initrd less kernel user I can really only agree: getting rid
>> of the udev-in-initrd requirement would be a big step forward
>> in usability. Typically I always have to pre populate
>> a on disk /dev manually first to get my kernels to boot.
>
> Oh good, I thought I was the only one doing that.
>
> The reason I don't like udev is that it's just to slow; something like a 5-10s
> delay on each boot.  No idea why it should be so slow,

Because you setup is broken, I guess.

> but it's probably
> probing the kernel for all available devices at boot, when it could be much
> quicker by probing for the device on access.

It takes more like 0.5 - 0.7 seconds on a usual setup.

Kay
