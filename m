Return-Path: <linux-kernel-owner+w=401wt.eu-S1762489AbXFTH6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762489AbXFTH6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 03:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759976AbXFTH6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 03:58:39 -0400
Received: from [60.23.248.87] ([60.23.248.87]:57317 "EHLO virgo.fc-cn.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756922AbXFTH6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 03:58:38 -0400
X-Greylist: delayed 1452 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jun 2007 03:58:38 EDT
Message-ID: <4678D882.3090606@mail.fc-cn.com>
Date: Wed, 20 Jun 2007 15:34:26 +0800
From: Qi Yong <qiyong@mail.fc-cn.com>
Organization: FCD
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070217 Iceape/1.1.1 (Debian-1.1.1-2)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, michal.k.k.piotrowski@gmail.com
Subject: Re: [patch] add printk_ratelimit to atkbd_interrupt
References: <20070620011753.GA16692@virgo.fc-cn.com> <200706200013.13029.dtor@insightbb.com>
In-Reply-To: <200706200013.13029.dtor@insightbb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Tuesday 19 June 2007 21:17, Qi Yong wrote:
>   
>> Add printk_ratelimit() to atkbd_interrupt(). I get "Spurious ACK" messages flushing on my
>> screen. This patch helps to read the screen.
>>
>>     
>
> Will apply, thank you.
>
> Do you have any idea why you are getting spurios ACK messages? Do you have
> an application fiddling with keyboard port or do you have blink driver
> enabled?

No idea. It is at boot time.
Yes, i have CONFIG_BLINK=y.

(add CC: Michal Piotrowski)

-- 
Qi Yong

