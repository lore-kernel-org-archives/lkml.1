Return-Path: <linux-kernel-owner+w=401wt.eu-S1752394AbXIHHVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbXIHHVo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 03:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbXIHHVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 03:21:36 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58546 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbXIHHVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 03:21:36 -0400
Date: Sat, 8 Sep 2007 09:21:35 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: davide rossetti <davide.rossetti@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: origin of __tmp1930643048 network device name: kernel-space or
 user-space
In-Reply-To: <6e7a378f0709070944l23ac5ca5te6e204e215457c59@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709080921150.25942@fbirervta.pbzchgretzou.qr>
References: <6e7a378f0709041014m24448117s96d6f9b60fad7872@mail.gmail.com> 
 <Pine.LNX.4.64.0709061448390.25942@fbirervta.pbzchgretzou.qr> 
 <20070906133551.GA25155@nostromo.devel.redhat.com> 
 <6e7a378f0709060802r677b4a8emb9c8cb7530f8028b@mail.gmail.com>
 <6e7a378f0709070944l23ac5ca5te6e204e215457c59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 7 2007 18:44, davide rossetti wrote:
>
>> > I'm assuming you're running some sort of Fedora/RHEL/
>> > derivative; this is what you get when you have a device that starts
>> > out named ethX, but which needed to be renamed so that an already
>> > configured ethX could be changed to that name.
>>
>> yes, it's FC6.
>>
>> > For the new device, either add a HWADDR in a ifcfg-ethX file for
>> > that interface, add something to /etc/mactab, or add a udev rule.
>>
>> seems like HWADDR is incompatible with bonding.... there is some
>> message using HWADDR as well as MASTER=bond0 and SLAVE=yes.
>
>for the records I worked-around it:
>- problem seems to be the interface 'bond0', which is started first,
>stops the ability to create another device named 'eth0' (WHY?)
>- so I shifted all of the interface names: 0->1, 1->2,...
>now it is ok. still I do not understand why bond0 seems to interfere
>with eth0...

Fedora says it all.
