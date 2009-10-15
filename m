Return-Path: <linux-kernel-owner+w=401wt.eu-S1762790AbZJOPX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762790AbZJOPX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762137AbZJOPX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:23:28 -0400
Received: from [207.36.208.214] ([207.36.208.214]:45774 "EHLO mail.dvmed.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1762103AbZJOPX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:23:28 -0400
Message-ID: <4AD73E40.1010501@garzik.org>
Date: Thu, 15 Oct 2009 11:22:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Remove or convert empty ioctls ?
References: <alpine.LFD.2.00.0910151113340.9428@localhost.localdomain>	<4AD711BC.2030409@garzik.org> <20091015160109.6d9353e8@lxorguk.ukuu.org.uk>
In-Reply-To: <20091015160109.6d9353e8@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2009 11:01 AM, Alan Cox wrote:
>> "no particular value" is highly subjective, and I think unprovable,
>> without an exhaustive survey of userland programs interacting with
>> kernel drivers.  Userland programs often interact with a -class- of
>> drivers, expecting predictable behavior from a DoThisThing ioctl, with
>> EINVAL or "other weird error code" returned intentionally.
>>
>> Changing the return codes seems quite unwise.
>
> We've changed lots of them to -ENOTTY over the past few years, nobody has
> even noticed (you included ;))
>
> SuS says an unknown ioctl code returns -ENOTTY.

These are not unknown ioctls; they are ioctls that the driver author 
close to implement rather than the default (ENOTTY).

	Jeff




