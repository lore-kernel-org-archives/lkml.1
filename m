Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbZJGVRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbZJGVRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbZJGVRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:17:13 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:35847 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbZJGVRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:17:13 -0400
MIME-Version: 1.0
In-Reply-To: <20091007221001.7628c9aa@lxorguk.ukuu.org.uk>
References: <20091007175403.GA335@trillian.comsick.at> <9b2b86520910071246r393f2afvacaa4d8f544508a8@mail.gmail.com> 
	<ac3eb2510910071306r4ad6dc9btb7503bc3ab0ec815@mail.gmail.com> 
	<ac3eb2510910071312qe6ad45ep6c579a8393cc6b8e@mail.gmail.com> 
	<20091007203121.GA432@trillian.comsick.at> <ac3eb2510910071353v3bbe5bc7lc41e184fbc1ff7ed@mail.gmail.com> 
	<20091007221001.7628c9aa@lxorguk.ukuu.org.uk>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 7 Oct 2009 23:15:45 +0200
Message-ID: <ac3eb2510910071415k5f6311d6y4d5119d16fbbc679@mail.gmail.com>
Subject: Re: [BUG] No ttyS0 - Strange udev 8250_pnp interaction
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Michael Guntsche <mike@it-loops.com>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-hotplug <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 23:10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 7 Oct 2009 22:53:12 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> On Wed, Oct 7, 2009 at 22:31, Michael Guntsche <mike@it-loops.com> wrote:
>> > add      /module/8250_pnp (module)
>> > remove /devices/platform/serial8250/tty/ttyS0 (tty)
>> > add      /devices/pnp0/00:05/tty/ttyS0 (tty)
>>
>> That's pretty odd, that the loading of a module removes pre-existing
>> devices created by other code, and creates new ones with the same name
>> and major/minor.
>
> Quite normal. The serial code has always done this.

Heh, I hope you don't tell people to look at floppy.c if they want to see
something "normal". :)

Kay
