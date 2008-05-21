Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbYEUHpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbYEUHpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 03:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759761AbYEUHp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 03:45:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:8750 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520AbYEUHp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 03:45:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=iIVL/CvojRE3mbhexsCvGatLMDOMfPCiFUTKriBm9SoqMYtdxOaa2te8mWgZCNZBPKdGP2hyF8JoU6HMTUloBNdjGTTZNMXuZiBJMR2CJ2+Ew/f+ZVc9CnFXcxJxhXzpcLbBLKRzmX185/H3L+dOOTkZA1MD+aCE4WAB9UY+z2k=
Message-ID: <4833D2EF.5090401@gmail.com>
Date: Wed, 21 May 2008 09:44:47 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Mudeem Siddiqui <mudeem@quartics.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: VM: killing process - How to identify the problem
References: <87A697E50899F541B77272C331CEB74401746058@exchange.Q-DOMAIN>
In-Reply-To: <87A697E50899F541B77272C331CEB74401746058@exchange.Q-DOMAIN>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2008 11:10 PM, Mudeem Siddiqui wrote:
> Hi all, 
> 
> I have linux 2.4.25 on a mips processor. Other than my application, the

Just curious, is is a typo?

> other processes that are running on the system are udhcpd, dhcpd,
> mini_dns etc. The applicaiton is quite memory intensive, it has
> allocated 5 MB of a buffer which acts as a queue and the applicaiton
> queues and de-queues packets in the queue at frequents intervals. The
> memory for this buffer is allocated just once when the application
> starts at the time of boot. So I would assume that there would be quite
> a lot of paging going on. 
> 
> The issue is that randomly the application gets killed, there is no
> segmnetation fault or anything and if I look at /var/log/messages I see
> quite a lot of 
> 
> __alloc_pages: 0-order allocation failed 
> __alloc_pages: 0-order allocation failed 
> __alloc_pages: 0-order allocation failed 
> 
> 
> and then 
> 
> VM: killing process 

Caused by out of memory, a page fault couldn't be serviced due to memory 
exhaustion. See arch/mips/mm/fault.c.
