Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbYAYPDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbYAYPDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759050AbYAYPC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:02:58 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:35309 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757681AbYAYPC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:02:57 -0500
Date: Fri, 25 Jan 2008 16:02:56 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jack Harvard <jack.harvard@googlemail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Q: linux failed to execute /init?
In-Reply-To: <a72f6a3c0801250639i4a7858eem415594f5663a9c7e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801251601360.15243@fbirervta.pbzchgretzou.qr>
References: <a72f6a3c0801250538m57a91629o59242fad9e7d0265@mail.gmail.com> 
 <a72f6a3c0801250540l73aacf9bvcebf50c23da3943e@mail.gmail.com> 
 <Pine.LNX.4.64.0801251524510.15243@fbirervta.pbzchgretzou.qr>
 <a72f6a3c0801250639i4a7858eem415594f5663a9c7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 25 2008 14:39, Jack Harvard wrote:
>> On Jan 25 2008 13:40, Jack Harvard wrote:
>> >Hi,
>> >
>> >I'm trying to boot Linux, but the /init process failed. Here is the
>> >info:
>> >
>> >=FF<6>/init exit code: -14
>> >/init exit code: -14
>> ><4>Failed to execute /init
>> >Failed to execute /init
>> > <6>/sbin/init exit code: -14
>> >
>> >Just wondering what do those different exit codes mean?
>>
>> asm-generic/errno-base.h:#define EFAULT 14 /* Bad address */
>>
>
>Also, before the init process hung up and printed out /init exit code:
>-14, it printed out the following symbol
>ÿ
>Which doesn't make any sense to me, just wondering what could have
>caused this? it's unlikely due to baud rate and printed out something
>unreadable.

ÿ is 255. While this could indicate a serial transmission error (my
guess: bad timing), printing -14 repeatedly certainly does not.
Is the ÿ reproducable, does it happen every time?
