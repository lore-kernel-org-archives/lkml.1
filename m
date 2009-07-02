Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbZGBLn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbZGBLn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 07:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZGBLns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 07:43:48 -0400
Received: from mail.anarazel.de ([217.115.131.40]:33658 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbZGBLnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 07:43:47 -0400
Message-ID: <4A4C9D75.5010300@anarazel.de>
Date: Thu, 02 Jul 2009 13:43:49 +0200
From: Andres Freund <andres@anarazel.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090629 Shredder/3.0b3pre
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (possibly	caused
 by netem)
References: <4A4A9DD6.8060800@anarazel.de> <4A4BAD5F.7050908@gmail.com> <4A4BD384.3090407@anarazel.de> <4A4C0144.5070203@anarazel.de> <20090702093031.GC4954@ff.dom.local> <20090702101207.GA7056@ff.dom.local> <4A4C95FC.7040305@anarazel.de>
In-Reply-To: <4A4C95FC.7040305@anarazel.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2009 01:11 PM, Andres Freund wrote:
> On 07/02/2009 12:12 PM, Jarek Poplawski wrote:
>> On Thu, Jul 02, 2009 at 09:30:31AM +0000, Jarek Poplawski wrote:
>>> On Thu, Jul 02, 2009 at 02:37:24AM +0200, Andres Freund wrote:
>>> ...
>>>> So I tried - and I did not catch any lockdep output before the crash.
>>>> Unfortunately I do not have another machine on the same local
>>>> network to
>>>> catch any messages after the crash... So I could be missing some
>>>> warning
>>>> (I did synchronous logging though).
>>>> Will check with netconsole tomorrow.
>>>
>>> Could you try if this patch changes anything?
>>
>> ...and maybe CONFIG_PACKET_MMAP turned off.
> Ok. Removed the skb_orphan and turned of CONFIG_PACKET_MMAP. Seemingly
> the same game.
> I now had another computer to catch the netconsole output. Still no
> lockdep warnings.
>
> Unfortunately the other computer was a windows machine with its strange
> terminal, so long lines are wrapped at 80cols, but that shouldn't be too
> bad.
I will start trying to place the issue by testing with existing kernels 
between 2.6.30 and now.

Andres
