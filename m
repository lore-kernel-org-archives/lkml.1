Return-Path: <linux-kernel-owner+w=401wt.eu-S1753213AbZHJJXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbZHJJXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbZHJJXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:23:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50258 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883AbZHJJXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:23:22 -0400
Message-ID: <4A7FE6F1.7030106@redhat.com>
Date: Mon, 10 Aug 2009 11:22:57 +0200
From: Harald Hoyer <harald@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
References: <20090805171513.GA10443@kroah.com> <200908062006.16263.a1426z@gawab.com> <20090806183653.GC28433@kroah.com> <200908062318.05478.a1426z@gawab.com>
In-Reply-To: <200908062318.05478.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2009 10:18 PM, Al Boldi wrote:
> Greg KH wrote:
>> On Thu, Aug 06, 2009 at 08:06:16PM +0300, Al Boldi wrote:
>>> Andi Kleen wrote:
>>>> Greg KH<greg@kroah.com>  writes:
>>>>> It makes the userspace boot process much simpler and easier to
>>>>> maintain, as well as providing a way to handle rescue disks and
>>>>> images trivially, and it makes the kernel _less_ dependant on the
>>>>> early userspace bootup scripts.
>>>> As a initrd less kernel user I can really only agree: getting rid
>>>> of the udev-in-initrd requirement would be a big step forward
>>>> in usability. Typically I always have to pre populate
>>>> a on disk /dev manually first to get my kernels to boot.
>>> Oh good, I thought I was the only one doing that.
>>>
>>> The reason I don't like udev is that it's just to slow; something like a
>>> 5-10s delay on each boot.  No idea why it should be so slow, but it's
>>> probably probing the kernel for all available devices at boot, when it
>>> could be much quicker by probing for the device on access.
>> Like Kay stated, this sounds like a misconfiguration of your distro's
>> udev setup, as the ones I use (openSUSE and Gentoo) do not have this
>> problem at all.
>
> Maybe they are using the same trick as Ubuntu and Debian, as they run udev in
> the background to hide the slowness.  Both Fedora and Mandriva run udev in
> the foreground where the slowness is visible.

On Fedora parallel to udev, readahead is running, which makes you think udev is 
slow, but in the end readahead speeds up the boot process by 10%.

>
> So really, if devtmpfs compares to udev speeds then this just looks like a
> devfs comeback.  Remember, devfs was really slow.
>
>
> Thanks!
>
> --
> Al
>

