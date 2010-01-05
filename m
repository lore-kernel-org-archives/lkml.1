Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239Ab0AEV7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab0AEV7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:59:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188Ab0AEV7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:59:51 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43346 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab0AEV7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:59:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=XEH+O+LgdFdwixZIxdWvpWqlON5iemJTmbGEA0ux1XXtP/C3XOLPhfpXtDxVTwOTc4
         +2CGsbfgVJNMWm5JbbUy3qIe5+A8qsMIagtzvx5N649OHjy8U/hkJDV64SZ2kPntcqo4
         Evac9wHy2zg8LADNL5q268ofMHIRclrh1eiF8=
MIME-Version: 1.0
In-Reply-To: <20100105211522.57A3E33C5F5@tippex.mynet.homeunix.org>
References: <20100105110256.D2DF133C4B0@tippex.mynet.homeunix.org> 
	<86802c441001051102j547f10bga2b40fbaee9cf623@mail.gmail.com> 
	<20100105211522.57A3E33C5F5@tippex.mynet.homeunix.org>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Tue, 5 Jan 2010 16:59:27 -0500
Message-ID: <3e8340491001051359m799df6bai86ec42dfff96f0f0@mail.gmail.com>
Subject: Re: Memory probing fails after 2.6.30 (bisected)
To: Anders Eriksson <aeriksson@fastmail.fm>
Cc: Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 5, 2010 at 4:15 PM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
>
> yinghai@kernel.org said:
>> whole boot log with debug with boot command line?
>>
>> > I can produce a pic of the dmesg for the fingered commit of needed.
>> boot that with earlyprintk=vga please.
>
> I managed to pull this one from the failing boot.
> Does it help?
>
> Linux version 2.6.30-rc2-00450-g8ecee46 (root@korven) (gcc version 4.3.2 (Gentoo 4.3.2-r3 p1.6, pie-10.1.5) ) #21 SMP Tue Jan 5 10:45:52 CET 2010
[...]
> EXT3-fs: mounted filesystem with writeback data mode.
> VFS: Mounted root (ext3 filesystem) readonly on device 8:5.
> Freeing unused kernel memory: 324k freed
> EXT3 FS on sda5, internal journal

Looks like the boot succeeded, at least long enough to mount the root
fs. Assuming you're not using bootsplash or something, you should have
seen something. Are you sure this is the log from the failed boot? If
it didn't make it to userspace, it won't leave anything in kern.log.
