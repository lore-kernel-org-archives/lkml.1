Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbYF3KaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbYF3KaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 06:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYF3KaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 06:30:05 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:41034 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbYF3KaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 06:30:04 -0400
Message-ID: <4868B5A8.2060004@aitel.hist.no>
Date: Mon, 30 Jun 2008 12:30:00 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
Organization: HiST
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <andi@firstfloor.org>,
       =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org> <8763rsphkt.fsf@basil.nowhere.org> <4867B20E.2030608@goop.org>
In-Reply-To: <4867B20E.2030608@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
>> Still there's the effect that Ctrl-Z+kill works faster than Ctrl-C
>> that is not explained by this. This has often annoyed me too.
>> I'm not sure why it is. In theory they should be the same unless
>> someone blocks SIGINT.
>>   
> 
> I'd never noticed that.  That's just weird.
> 
I occationally see this - although I rarely run loads so heavy that it 
is a real problem. Ctrl-C - nothing happens except maybe a ^C printed - 
kill it from another rxvt.

Could it be some sort of tty locking issue, holding up Ctrl-C processing
while the heavily loaded machine suffer lock contention?

Last time I saw this was a erroneous script that called itself without
exec. With 2G memory and 3G of swap in use, the system was slow. the 
mouse cursor moved only now and then. Very little happened
with Ctrl-C. Closing the rxvt running this script then caused a lot of
disk activity and the system slowly came back to normal.

Helge Hafting
