Return-Path: <linux-kernel-owner+w=401wt.eu-S1752894AbZIROcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbZIROcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbZIROca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:32:30 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:51425 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZIROc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:32:29 -0400
MIME-Version: 1.0
In-Reply-To: <20090918162503.6735cc1b@infradead.org>
References: <m1y6oef08k.fsf@fess.ebiederm.org> <ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com> 
	<m1d45oxsrk.fsf@fess.ebiederm.org> <20090918160944.58e5c1f5@infradead.org> 
	<ac3eb2510909180711k223aeb6ena2de3645317d03bd@mail.gmail.com> 
	<20090918162503.6735cc1b@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 18 Sep 2009 16:32:18 +0200
Message-ID: <ac3eb2510909180732s6efc97b0o7b25d8da222088ca@mail.gmail.com>
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs 
	maintenance disaster
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18, 2009 at 16:25, Arjan van de Ven <arjan@infradead.org> wrote:
> On Fri, 18 Sep 2009 16:11:16 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> On Fri, Sep 18, 2009 at 16:09, Arjan van de Ven <arjan@infradead.org>
>> wrote:
>>
>> > frankly, modprobe should call the settle.
>>
>> We call modprobe from udev, and will have fun with such a solution.
>>
>
> too bad you cut my next sentence which said that there needed to be a
> way to opt out of that.

Too bad, bad we don't have control over all the udev rules out there
doing that, which will dead-lock then. And too bad that when udev
calls modprobe we still don't solve the races. Too bad that calling
"settle" waits for all events and you can never know when loading a
module what to wait for and what not. It's just not a close to a
solution that is doing any good. What's the point of all these weird
workarounds you are proposing? I think it's properly solved already.

Thanks,
Kay
