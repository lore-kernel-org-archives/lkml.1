Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0CCWDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 17:03:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:56448 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0CCWDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 17:03:32 -0500
MIME-Version: 1.0
In-Reply-To: <m1y6i9i2av.fsf@fess.ebiederm.org>
References: <20100302230933.GA32287@kroah.com> <1267572541-410-19-git-send-email-gregkh@suse.de> 
	<m1635eow8a.fsf@fess.ebiederm.org> <alpine.LFD.2.00.1003030839550.3627@localhost.localdomain> 
	<ac3eb2511003031203t2b30bbbjcb9a05e9851667ea@mail.gmail.com> 
	<m1y6i9i2av.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 3 Mar 2010 12:01:31 -1000
Message-ID: <ac3eb2511003031401m7e4155c1q769e3f60524a7dc3@mail.gmail.com>
Subject: Re: [PATCH 19/62] Driver-Core: devtmpfs - remove EXPERIMENTAL and 
	enable it by default
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 10:21, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Kay Sievers <kay.sievers@vrfy.org> writes:
>> For the "must have", we will not be able to bootup the upcoming Ubuntu
>> and openSUSE development distros without it, not sure about Fedora,
>> the support is there, but it might still work without it. Some smaller
>> distros also already depend on it.
>
> Is this a case of the initial ramdisks won't work, or have you removed
> support from udev to create device nodes?

Udev has not changed, it still works without any kernel-created nodes,
as it always did.

It's the distro-specific system coldplug/bootstrap logic that got
simplified with the kernel device-node support. There is more pending,
which will take the advantage of not needing to synchronize some
steps, like it was needed the former asynchronous device-node-creation
behavior. It affects initramfs and kernel-mounted rootfs setups, both
now expect devtmpfs to be available.

Kay
