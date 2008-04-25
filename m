Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbYDYHl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbYDYHl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 03:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbYDYHlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 03:41:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:25133 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYDYHlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 03:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=LLeoIA4xzlHdi0oUn3DcadD/8atvjZx+iLhiF1n1yLI2rAgfhILRKIuvgN4HSPm6Se//voPwOPlgh04JtJ8DZhbFe7MvxVGMLpfOcDTO5MCC/HoTXcPm9xu6JpoLLoMfZK8nn3WS85C2STkcSIk6Mlk+HJ9afWICM+Ssm/TRle4=
Message-ID: <48118B18.5020008@gmail.com>
Date: Fri, 25 Apr 2008 09:41:12 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, zdenek.kabelac@gmail.com, mingo@elte.hu,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com,
       Johannes Berg <johannes@sipsolutions.net>,
       Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
References: <4811090A.9030809@gmail.com>	<20080424.183558.96469288.davem@davemloft.net>	<alpine.LFD.1.10.0804241841280.2779@woody.linux-foundation.org> <20080424.185757.254044977.davem@davemloft.net>
In-Reply-To: <20080424.185757.254044977.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added 3 80211 experts.

On 04/25/2008 03:57 AM, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Thu, 24 Apr 2008 18:48:32 -0700 (PDT)
> 
>> But that 0xf0 definitely has shown up before. It's not the *only* 
>> corruption, but it's definitely a very interesting pattern. And the other 
>> ones that didn't show the 0xf0 pattern could obviously be due to pointers 
>> that were corrupted by 0xf0 in low bytes, so it _may_ be the source of the 
>> other corruptions too that didn't have an obvious 0xf0 directly in them.
> 
> Ok.
> 
> Do we know of any pattern of the wireless device type in use?
> If there is a pattern to that, it would be a huge clue.
> 
> And if it is predominantly one particular wireless device type, we
> should be able to come up with a patch to test.

Johannes, Michael, Jiri? Someone writes to freed memory patterns 0xf0 (not 
aligned to anything, addressed per byte), one of suspects is mac80211, don't you 
know that pattern from anywhere?

Thanks, Jiri.
