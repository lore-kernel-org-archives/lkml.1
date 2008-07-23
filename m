Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbYGWHSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbYGWHSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 03:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYGWHSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 03:18:37 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:63780 "EHLO
	pd5mo1no-dmz.prod.shaw.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751229AbYGWHSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 03:18:37 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=20KFwNOVAAAA:8 a=NYti9F7G8_d6_a-phHIA:9 a=UTurMECXin2--lS2YR843S3kQwMA:4 a=l9iCJtgIvv4A:10 a=GFZTb6icBPAA:10
Message-ID: <4886DB31.8070306@sieb.net>
Date: Wed, 23 Jul 2008 00:18:09 -0700
From: Samuel Sieb <samuel@sieb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.15) Gecko/20080706 Fedora/1.1.10-1.fc9 SeaMonkey/1.1.10
MIME-Version: 1.0
To: Juergen Beisert <jbe@pengutronix.de>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Magnus Damm <magnus@valinux.co.jp>, takada <takada@mbf.nifty.com>
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
References: <48841A92.4020301@sieb.net> <48856BC6.7030308@sieb.net> <20080722102457.GA773@elte.hu> <200807221251.10843.jbe@pengutronix.de>
In-Reply-To: <200807221251.10843.jbe@pengutronix.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Juergen Beisert wrote:
> On Dienstag, 22. Juli 2008, Ingo Molnar wrote:
>> could you try to figure out which particular use of getCx86() or
>> setCx86() makes the difference? Here are the suspect nested ones, for
>> which the macro->inline change can be material:
>>
>> $ grep -n 'Cx86.*Cx86' arch/x86/kernel/*/*.c > 1
>>
>> i've applied the patch below to tip/master:
>>
>>    http://people.redhat.com/mingo/tip.git/README
>>
>> could you check whether it boots your system fine, out of box?

It doesn't.

> The only critical tweak I found is the one that changes the "Performance 
> Control Incrementer" because its settings depends on the CPU's core 
> frequency.
> Maybe this tweak should be removed, because the BIOS (hopefully) set it in a 
> way the hardware supports.
> 
This was the only line that was a problem.  See the other branch of this 
thread with Juergen Beisert.

