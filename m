Return-Path: <linux-kernel-owner+w=401wt.eu-S1764265AbXHIUBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764265AbXHIUBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 16:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbXHIUB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 16:01:29 -0400
Received: from rwcrmhc14.comcast.net ([216.148.227.154]:57324 "EHLO
	rwcrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbXHIUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 16:01:28 -0400
Subject: Re: Kernel / Fliesystem Error
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Benoit Boissinot <bboissin@gmail.com>
Cc: Chris Holvenstot <saltydog@houston.rr.com>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <40f323d00708090531p34f1fffcub5186d358f9beafb@mail.gmail.com>
References: <1186623555.6613.17.camel@localhost>
	 <1186658730.7018.8.camel@localhost>
	 <40f323d00708090531p34f1fffcub5186d358f9beafb@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 15:02:56 -0500
Message-Id: <1186689776.6976.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit - 

I am a little unsure of the protocol involved here but I will respond to
this, the last message I received on the topic.

As I feared, I was giving an incomplete picture with my original report
and did not even realize it.  

On the systems I was getting  the error on I used the mkinitramfs
command to build the initrd.img file.  This was basically the 2.6.23
systems.  I did this because the documentation seemed to indicate that
this would clear up the "devfs unknown file system" messages I was
getting at boot.

Which it did.

However, when I rebuilt the 2.6.22.1 kernel's initrd.img file with
mkinitramfs instead of mkinitrd the 2.6.22.1 kernel started getting the
"superblock time stamp" errors too.

So the problem is NOT with the kernel code - it appears to be either
with mkinitramfs or my process.  With the way my luck has been running
of late it is likely that the fault is with my process.

So I once again thank you for your response, and apologize for what now
appears to be a false alarm.  Since the initramfs tool set was provided
with the Ubuntu release I am using as a base I will try to locate
someone there to assist with this issue.

Chris



On Thu, 2007-08-09 at 14:31 +0200, Benoit Boissinot wrote:
> On 8/9/07, Chris Holvenstot <cholvenstot@comcast.net> wrote:
> > > Chris Snook wrote:
> > >
> > >The problem here is that your clock is wrong either at mount (boot)
> > >time or unmount (shutdown) time. There's nothing wrong with ext3,
> > >except that it happens to be noticing this condition.
> >
> > 1.  This happens even when the system is rebooted via the shutdown -r
> > command - not much time for my fat fingers to get in there and dork up
> > the system clock.
> >
> > 2.  As I stated in the original note, this does NOT happen with kernel
> > 2.6.22.1 - so far I have only seen it with the 2.6.23-rc1, rc2, and
> > rc2-git1 kernels.
> >
> 
> But very likely time keeping was broken between .22 and .23-rc.
> Probably not ext3.
> 
> regards,
> 
> Benoit

