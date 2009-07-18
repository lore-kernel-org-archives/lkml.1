Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZGRQMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZGRQMi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 12:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZGRQMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 12:12:36 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:62332 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbZGRQMf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 12:12:35 -0400
MIME-Version: 1.0
In-Reply-To: <20090718160101.GA13346@kroah.com>
References: <1247931257.29760.1.camel@yio.site> <20090718160101.GA13346@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 18 Jul 2009 18:12:20 +0200
Message-ID: <ac3eb2510907180912u7b30d8actcfab15776fe2d99d@mail.gmail.com>
Subject: Re: vc: create vcs(a) devices for consoles
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Gerardo Exequiel Pozzi <vmlinuz386@yahoo.com.ar>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 18:01, Greg KH<greg@kroah.com> wrote:
> On Sat, Jul 18, 2009 at 05:34:17PM +0200, Kay Sievers wrote:
>> From: Kay Sievers <kay.sievers@vrfy.org>
>> Subject: vc: create vcs(a) devices for consoles
>>
>> The buffer for the consoles are unconditionally allocated at
>> con_init() time, which miss the creation of the vcs(a) devices.
>>
>> Since 2.6.30, these devices are no longer created at open()
>> and removed on close(), but controlled by the lifetime of the
>> buffers.
>
> Is this a bug in .31-rc right now?  Should this make it into the final
> .31 release?

Yes, and in .30.

> And what caused this change, tty changes?  If so, it should go through
> Alan Cox's tree.

This change caused it:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4995f8ef9d3aac72745e12419d7fbaa8d01b1d81

Thanks,
Kay
