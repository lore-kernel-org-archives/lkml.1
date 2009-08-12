Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZHLBUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZHLBUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 21:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZHLBUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 21:20:37 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:52610 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbZHLBUh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 21:20:37 -0400
MIME-Version: 1.0
In-Reply-To: <20090810155431.GA1505@ucw.cz>
References: <20090805171513.GA10443@kroah.com> <20090809120902.GC1338@ucw.cz> 
	<20090810163652.GB28091@kroah.com> <20090810155431.GA1505@ucw.cz>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 12 Aug 2009 03:20:23 +0200
Message-ID: <ac3eb2510908111820u3a21084m45823a7e9286d6d5@mail.gmail.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based 
	/dev
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 17:54, Pavel Machek<pavel@ucw.cz> wrote:

>> > > +#if defined CONFIG_DEVTMPFS_MOUNT
>> > > +static int dev_mount = 1;
>> > > +#else
>> > > +static int dev_mount;
>> > > +#endif
>> >
>> >
>> > A bit too many config options?
>>
>> It's only 1 option, is that 1 too many for you?
>
> It is two, and this option duplicates  commandline
> option. Maybe its better to use config_cmdline at that point?

Sure, if you want to do that, I wouldn't mind to drop the
CONFIG_DEVTMPFS_MOUNT, if we mount it by default, and have the command
line to overwrite the setting.

Kay
