Return-Path: <linux-kernel-owner+w=401wt.eu-S1753740AbYITMu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbYITMu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 08:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYITMuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 08:50:18 -0400
Received: from pih-relay06.plus.net ([212.159.14.19]:52274 "EHLO
	pih-relay06.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYITMuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 08:50:18 -0400
Message-ID: <48D4F18A.7080302@yahoo.com>
Date: Sat, 20 Sep 2008 13:50:18 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: Reading EeePC900 battery info causes stalls
References: <fa.aea4e10hJLpVS/qr4bumSa5e9C0@ifi.uio.no> <fa.uDmoMIWw4thxpZxpYeSIpVJhAOo@ifi.uio.no> <fa.RIMmQqN9ybFSKBqOk9Gxi/mOeB4@ifi.uio.no> <fa.XLGLzP+T4fm9CkeATkS1VL/Yz4Q@ifi.uio.no> <fa.z8sKLpwDO3qQ15ZJIm152YEty4I@ifi.uio.no> <fa.KyW7dWWjiSFnFxwdZZLurmVn8qA@ifi.uio.no> <48D4CC1B.7030708@yahoo.com> <48D4CFA5.7010501@suse.de> <48D4D5CA.1060104@yahoo.com> <48D4D6AE.70705@yahoo.com> <48D4DB23.5080901@suse.de> <48D4DD3C.3050308@yahoo.com> <48D4E180.4050907@yahoo.com> <48D4EDD2.5030603@suse.de>
In-Reply-To: <48D4EDD2.5030603@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: b46f82608eac4f4a3311d60f8a3f1b28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:
> Sitsofe Wheeler wrote:
>> and here is the kernel cmdline that the Xandros install uses:
>> quiet rw vga=785 irqpoll root=/dev/sda1
>>
>> I've got a feeling I know what direction this is going in...
>>
> Right, could you please check if irqpoll is the key to success?

So I tried just irqpoll (along with nolapic irqpool which changed the 
output in /proc/interrupts) but it made no difference to the stalling. 
I'm baffled.

-- 
Sitsofe | http://sucs.org/~sits/
