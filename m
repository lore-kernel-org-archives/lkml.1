Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZKJMFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZKJMFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZKJMFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:05:06 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34414 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZKJMFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:05:05 -0500
Message-ID: <4AF956F8.7090707@davidnewall.com>
Date: Tue, 10 Nov 2009 22:35:12 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Clemens Ladisch <clemens@ladisch.de>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vt: make the default cursor shape configurable
References: <4AF7D439.4030305@ladisch.de> <20091109091044.GX29442@buzzloop.caiaq.de> <4AF7DDC1.4090006@ladisch.de> <20091109095316.6283fbd6@lxorguk.ukuu.org.uk> <4AF7FC64.6030904@ladisch.de> <20091109114600.4d91b90e@lxorguk.ukuu.org.uk> <20091109145056.GB14091@buzzloop.caiaq.de> <4AF8582B.2000403@davidnewall.com> <20091109220944.GH14091@buzzloop.caiaq.de>
In-Reply-To: <20091109220944.GH14091@buzzloop.caiaq.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack wrote:
> On Tue, Nov 10, 2009 at 04:28:03AM +1030, David Newall wrote:
>   
>> Daniel Mack wrote:
>>     
>>> And even if the cursor behaviour is changable at runtime, I don't see
>>> why it shouldn't have a selectable compile time default. Which is what
>>> the patch adds.
>>>       
>> It seems like adding cruft to the kernel that is just as effectively
>> available at run-time. Where does it end? Do we eventually add bash to
>> the kernel?
>>     
>
> One more thing:
>
> Clemens' last patch didn't add anything to the kernel's binary size.
> It didn't slow down anything either, as there is no run-time condition
> evaluation. It just makes something configurable which was hard
> coded before. So where's the cruft?
>   

In this case the cruft is yet more kernel configuration choices to
confuse and bewilder. The problems caused by cruft are more from its
accretion than from any single part of it. Being able to argue that a
crufty feature causes no change to speed or size misses that point.

Everything should be in the kernel, except those things that don't need
to be (with apologies to Enstein).

I'm having trouble seeing a flashing cursor during device startup as a
problem. I expect it will prove a useful diagnostic, one day. I think
you can turn it off (from user space) within a couple of seconds of
power on; you did say embedded, didn't you? Perhaps you even can
configure your hardware to not display the cursor on startup, which is
the second likeliest (after user-space) place to satisfy your needs.
