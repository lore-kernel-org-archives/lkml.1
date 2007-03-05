Return-Path: <linux-kernel-owner+w=401wt.eu-S933528AbXCEPk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528AbXCEPk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933525AbXCEPk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:40:59 -0500
Received: from mail.tmr.com ([64.65.253.246]:58279 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933528AbXCEPk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:40:58 -0500
Message-ID: <45EC3A76.3040004@tmr.com>
Date: Mon, 05 Mar 2007 10:42:46 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, jamagallon@ono.com,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>	<20070305011133.570a9ba8@werewolf-wl>	<20070304171737.42c14570.akpm@linux-foundation.org> <17899.32654.441273.208962@notabene.brown>
In-Reply-To: <17899.32654.441273.208962@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Sunday March 4, akpm@linux-foundation.org wrote:
>> On Mon, 5 Mar 2007 01:11:33 +0100 "J.A. Magallón" <jamagallon@ono.com> wrote:
>>
>>> On Fri, 2 Mar 2007 03:00:26 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>>> Temporarily at
>>>>
>>>>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
>>>>
>>>> Will appear later at
>>>>
>>>>   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
>>>>
>>> nfs blocks shutdown and reboot.
>>> If I try to do 'service nfs stop', the box hangs, no login, no SysRQ-T or P,
>>> S-U-B works at least.
>>>
>> The bug was added by
>> knfsd-use-recv_msg-to-get-peer-address-for-nfsd-instead-of-code-copying.patch.
> 
> Bother.......
> Looks like a need a MSG_DONTWAIT in there, don't I.
> 
> I'll resend.

Crap, that's probably in 2.6.20-git14 with all the NFS stuff I thought I 
had checked before trusting. At least there is a bug found, no more 
"works for me" reports. I'll revert to an FC6 kernel before load gets 
high this morning.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

