Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbZEGCJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbZEGCJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 22:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbZEGCIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 22:08:54 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:55268 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757267AbZEGCIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 22:08:53 -0400
MIME-Version: 1.0
In-Reply-To: <20090506184122.721c890d@infradead.org>
References: <1241097822.2516.3.camel@poy> <20090506184122.721c890d@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 7 May 2009 04:08:33 +0200
Message-ID: <ac3eb2510905061908u7acbd1b2nf991aa85e1517fe4@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 03:41, Arjan van de Ven <arjan@infradead.org> wrote:
> On Thu, 30 Apr 2009 15:23:42 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: driver-core: devtmpfs - driver core maintained /dev tmpfs
>>
>> Devtmpfs lets the kernel create a tmpfs very early at kernel
>> initialization, before any driver core device is registered. Every
>> device with a major/minor will have a device node created in this
>> tmpfs instance. After the rootfs is mounted by the kernel, the
>> populated tmpfs is mounted at /dev. In initramfs, it can be moved
>> to the manually mounted root filesystem before /sbin/init is
>> executed.
>
> so just to state the obvious: this code is not needed to boot fast.
> It is mostly a workaround for having a bad initrd; if you don't use an
> initrd, or if you use an initrd that's made with the right device nodes
> in it already, you really just don't need this.
>
> I would much rather that you just fix your initrd... than to put this
> sort of thing into the kernel....

How will you solve the dynamic device numbers? They are a complete
reality today.

Thanks,
Kay
