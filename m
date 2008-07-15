Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbYGOFba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbYGOFba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 01:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbYGOFbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 01:31:03 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:49211 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbYGOFbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 01:31:00 -0400
Message-ID: <487C367D.4060808@keyaccess.nl>
Date: Tue, 15 Jul 2008 07:32:45 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       david@lang.hm, akpm@linux-foundation.org, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel,
 use it in more drivers.
References: <487C0A12.9060906@keyaccess.nl>	<20080714.192425.241878700.davem@davemloft.net>	<alpine.LFD.1.10.0807141934060.3017@woody.linux-foundation.org>	<20080714.194557.78177585.davem@davemloft.net> <20080714215648.1ed29448@infradead.org>
In-Reply-To: <20080714215648.1ed29448@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-07-08 06:56, Arjan van de Ven wrote:

> On Mon, 14 Jul 2008 19:45:57 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
>> From: Linus Torvalds <torvalds@linux-foundation.org>
>> Date: Mon, 14 Jul 2008 19:39:03 -0700 (PDT)
>>
>>> Put this way: if you do a distro, you _need_ to support firmware
>>> loading anyway. And once you do that, it's just annoying how some
>>> drivers then do something odd and special for the same thing, for
>>> no real good reason.
>> In what way is it annoying?
>>
>> Most distribution people aren't even aware that drivers like tg3 and
>> bnx2 even have firmware.  In fact it's self contained and less for
>> them to worry about.
> 
> and.. after this patch that still seems to be the case, unless I'm
> looking at it really cross eyed.
> Nothing in this patch makes it impossible to do so.. or changes the
> drivers you mention. in fact it's the opposite almost: it improves
> request_firmware() usability significantly. (by allowing vmlinux build
> in etc).

Only by virtue of those specific drivers having been skipped for now. 
For those that weren't skipped, the only way to have them still be self 
contained is to have the kernel itself compile in all firmware for all 
modules after which the module will find it there. Distributions will of 
course not do this, not does it make any sense for own kernels.

Rene.
