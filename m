Return-Path: <linux-kernel-owner+w=401wt.eu-S1761886AbYBEV7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886AbYBEV7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbYBEV7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:59:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:24140 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbYBEV7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:59:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=kI329odec15k90rmc3IQfKU8yuur5Kr7SKg28kV2YT+ZCEaviILN49u1QEhnGX1q6XMmFcQHcNfMvCwh0fPxAOOAa3FuY00XihCt5/2dISbufQbkzPq6yo90PfMKJW0N1vj2UxiWaK12ZNDvsb1tyJZsUOTufPZdZxC/MwNLkWY=
Message-ID: <47A8DC2B.20604@gmail.com>
Date: Tue, 05 Feb 2008 22:59:07 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Paul Fulghum <paulkf@microgate.com>
CC: Rick Warner <rick@microway.com>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: serial port regression caused by "Char: tty_ioctl, use wait_event_interruptible_timeout"
 patch
References: <200802051402.26816.rick@microway.com> <47A8C4AB.3030301@microgate.com> <47A8CCC0.8020703@microgate.com> <200802051632.54058.rick@microway.com> <47A8D71F.4050601@microgate.com>
In-Reply-To: <47A8D71F.4050601@microgate.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2008 10:37 PM, Paul Fulghum wrote:
> Rick Warner wrote:
>> This modification solved my problem.  Will this change go into 
>> mainline, or will we need to maintain our own branch of the kernel to 
>> keep this working?
> 
> It should be accepted into mainline as it restores
> the original behavior. I'll put together a patch
> submission tomorrow unless Jiri beats me to it.

It should be fixed already as of
git-describe db99247a
v2.6.24-rc6-95-gdb99247

So since 2.6.24-rc7.

Maybe we should consider the fix for 2.6.23 too.
