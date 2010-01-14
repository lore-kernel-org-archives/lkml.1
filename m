Return-Path: <linux-kernel-owner+w=401wt.eu-S1751139Ab0ANFLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab0ANFLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 00:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016Ab0ANFLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 00:11:34 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42591 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0ANFLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 00:11:33 -0500
MIME-Version: 1.0
In-Reply-To: <20100114034909.GB27634@kroah.com>
References: <1263388596.26006.1.camel@yio.site> <20100114034909.GB27634@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 14 Jan 2010 06:11:16 +0100
Message-ID: <ac3eb2511001132111t7ac93f97xe1e54d93e3a43b02@mail.gmail.com>
Subject: Re: Driver-Core: devtmpfs - reset inode permissions before unlinking
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 04:49, Greg KH <greg@kroah.com> wrote:
> On Wed, Jan 13, 2010 at 02:16:36PM +0100, Kay Sievers wrote:
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: Driver-Core: devtmpfs - reset inode permissions before unlinking
>>
>> Before unlinking the inode, reset the current permissions of possible
>> references like hardlinks, so granted permissions can not be retained
>> across the device lifetime by creating hardlinks, in the unusual case
>> that there is a user-writable directory on the same filesystem.
>
> Is this something that we need to worry about for existing users
> (2.6.32 and .33), or can it wait until 2.6.34?

Should be fine for .34 only.

Thanks,
Kay
