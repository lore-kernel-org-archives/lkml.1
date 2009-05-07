Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbZEGPN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbZEGPN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760484AbZEGPNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:13:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:53059 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761665AbZEGPNV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:13:21 -0400
MIME-Version: 1.0
In-Reply-To: <20090507144353.GA7603@mit.edu>
References: <1241097822.2516.3.camel@poy> <m1vdodnx8e.fsf@fess.ebiederm.org> 
	<ac3eb2510905070228w5ecb5aa9ob24af17a91d2f231@mail.gmail.com> 
	<20090507144353.GA7603@mit.edu>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 7 May 2009 17:13:00 +0200
Message-ID: <ac3eb2510905070813i3f0cebc2t4685e7186481fb49@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Theodore Tso <tytso@mit.edu>, Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 16:43, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, May 07, 2009 at 11:28:19AM +0200, Kay Sievers wrote:
>> On Thu, May 7, 2009 at 10:17, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> > sysfs is slow.
>> > udev is slow.
>>
>> Everything is "slow" if you want to boot "fast". It's just numbers,
>> and this is more about simplicity and reliability, with just the side
>> effect that it's the fastest you can do, when you don't want to lose
>> current functionality.
>
> How much of this is because, say, udev is using shell scripts as
> opposed to C?  If the answer is you lose flexibility when you do it as
> shell script fragments, I just spent 30 minutes with Alsadair chewing
> on my ear about how udev's use of shell scripts is making dm/LVM's
> life hard --- and I'll note that if we solve this problem by bloating
> the kernel, you lose flexibility *anyway* since the kernel code will
> be in C and not shell scripts.  :-)

Udev does not use any shell scripts besides one for firmware loading
and one composing /dev/disk/by-path/ link names for block devices
without metadata. Both are very simple and cheap, and do not cause any
known problems for anybody.

It's probably not udev's fault, why people chew on your ear. Sorry, I
don't think I can solve that problem. :)

Thanks,
Kay
