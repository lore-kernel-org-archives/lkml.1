Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYGBUVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYGBUVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 16:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYGBUVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 16:21:37 -0400
Received: from khc.piap.pl ([195.187.100.11]:56878 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbYGBUVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 16:21:36 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: netdev@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: WAN: Remove dead code from wanmain.c, CONFIG_WANPIPE_MULTPPP doesn't exist
References: <m3r6ac3xs8.fsf@maximus.localdomain>
	<20080702201754.GA2145@cs181140183.pp.htv.fi>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 02 Jul 2008 22:21:34 +0200
In-Reply-To: <20080702201754.GA2145@cs181140183.pp.htv.fi> (Adrian Bunk's message of "Wed\, 2 Jul 2008 23\:17\:55 +0300")
Message-ID: <m363ro3ult.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:

>> -#ifdef CONFIG_WANPIPE_MULTPPP
>> -		pppdev = kzalloc(sizeof(struct ppp_device), GFP_KERNEL);
>> -		err = -ENOBUFS;
>> -		if (pppdev == NULL)
>> -			goto out;
>> -		pppdev->dev = kzalloc(sizeof(struct net_device), GFP_KERNEL);
>> -		if (pppdev->dev == NULL) {
>> -			kfree(pppdev);
>> -			err = -ENOBUFS;
>> -			goto out;
>> -		}
>> -		err = wandev->new_if(wandev, (struct net_device *)pppdev, cnf);
>> -		dev = pppdev->dev;
>> -#else
>>  		printk(KERN_INFO "%s: Wanpipe Mulit-Port PPP support has not been compiled in!\n",
>>  				wandev->name);
>
> The printk() also needs some updating.

Agreed.
-- 
Krzysztof Halasa
