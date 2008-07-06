Return-Path: <linux-kernel-owner+w=401wt.eu-S1758859AbYGFURl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859AbYGFURl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYGFURa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:17:30 -0400
Received: from mail.lang.hm ([64.81.33.126]:60724 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbYGFURa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:17:30 -0400
Date: Sun, 6 Jul 2008 13:17:51 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Miller <davem@davemloft.net>, jeff@garzik.org, dwmw2@infradead.org,
       andi@firstfloor.org, tytso@mit.edu, hugh@veritas.com,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       mchan@broadcom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
In-Reply-To: <20080704220444.011e7e61@lxorguk.ukuu.org.uk>
Message-ID: <alpine.DEB.1.10.0807061311030.11010@asgard.lang.hm>
References: <1215178035.10393.763.camel@pmac.infradead.org> <486E2818.1060003@garzik.org> <20080704142753.27848ff8@lxorguk.ukuu.org.uk> <20080704.134329.209642254.davem@davemloft.net> <20080704220444.011e7e61@lxorguk.ukuu.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008, Alan Cox wrote:

>> External firmware is by design an error prone system, even with
>> versioning.  But by being built and linked into the driver, it
>> is fool proof.
>>
>> On a technical basis alone, we would never disconnect a crucial
>> component such as firmware, from the driver.  The only thing
>> charging these transoformations, from day one, is legal concerns.
>
> As I said: We had this argument ten years ago (more than that now
> actually). People said the same thing about modules.
>

and they were right then as well. Fortunantly,at that time the kernel 
developers listened and retained the possibility to not use modules.

if David W were to make it possible to not use the load_firmware() call to 
userspace and build the firmware into the driver (be it in a monolithic 
kernel or the module that contains the driver) this would not be a 
problem. the default could be to build in the firmware (avoiding breakage) 
and those people and distros that see a reason to seperate the firmware 
would be able to by changing that setting.

we have also had the same argument about initrd/initramfs where people 
have wanted to make them mandatory by moving things (like partition 
detection) out of the kernel. so far this hasn't happened, and I hope it 
doesn't.

David Lang
