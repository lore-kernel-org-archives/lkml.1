Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbYLXPEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbYLXPEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 10:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYLXPEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 10:04:11 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:46957 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750701AbYLXPEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 10:04:10 -0500
Message-ID: <49524F81.4030301@ru.mvista.com>
Date: Wed, 24 Dec 2008 18:04:33 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: gregkh@suse.de
Cc: felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
       khilman@deeprootsystems.com,
       davinci-linux-open-source@linux.davincidsp.com, david-b@pacbell.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] musb: fix DaVinci build again
References: <200812072341.50012.sshtylyov@ru.mvista.com> <494A7729.6090102@ru.mvista.com> <494A7809.1040504@ru.mvista.com> <494E2450.9080601@ru.mvista.com> <4950CFAD.7020403@ru.mvista.com>
In-Reply-To: <4950CFAD.7020403@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>>> The last Kevin Hilman's patch seems to have been broken on its way 
>>>>> to Greg's
>>>>> tree and also probably clashed with yet another patch. Fix DaVinci 
>>>>> build again.
>>>>> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>>>>> ---
>>>>> Felipe, I have to ask you again to be more careful with patches...

>>>>    11 days have passed since this has benn sent out and I'm still 
>>>> not seeing this 2.6.28 *hot* fix in the MUSB git tree. Greg, could 
>>>> you queue this urgently, bypassing the MUSB tree?

>>>   I'll be happy if it gets combined with the following patch in your 
>>> tree:

>>> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/usb/usb-musb-build-fixes-for-davinci.patch 

>>> fallout of which I'm fixing. Though it would've been better yet if 
>>> you just dropped that totally broken patch. I could've send a 
>>> replacment then...

>>   The patch I liked to above fixes nothing and only adds more 
>> breakage. Compare it with the original Kevin's patch:

>> http://marc.info/?l=linux-usb&m=122608723815504

>   I'm seeing Felipe returning to the list but still ignoring this thread 
> so far.
>   For how much longer we'll have to wait for this issue to be resolved? 
> 2.6.28 is 2 days away (at most).
>   Greg, what's the problem with dropping obviously broken patch?

    Greg, looks like that *2.6.28* (acyually even 2.6.27) patch is even in the 
wrong sub-series (past-2.6.28) of your tree, so there was no hope on the 
timely resolution from the very start... sigh. :-(

WBR, Sergei
