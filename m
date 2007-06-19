Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbXFSKE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbXFSKE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 06:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757740AbXFSKEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 06:04:12 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:56548 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353AbXFSKEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 06:04:10 -0400
Message-ID: <4677AA06.4090600@bx.jp.nec.com>
Date: Tue, 19 Jun 2007 19:03:50 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take5 4/7] using symlink for the net_device
References: <466FC455.5060001@bx.jp.nec.com> <466FC6ED.9060208@bx.jp.nec.com> <a781481a0706130949j7b35e33ds9cda5d8a551c9d7d@mail.gmail.com>
In-Reply-To: <a781481a0706130949j7b35e33ds9cda5d8a551c9d7d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Satyam,

> Sorry, but we're not covering from the error condition fully here. Note
> that later you merge the temporary modify_target_list entirely back
> into the target_list ... which would still contain these erroneous
> nodes. A full cleanup (kobject_unregister the entry, and then list_del
> from modify_target_list) is required here, before continuing.

I will fix this. If the error occurs, I think so that we need to cleanup
completely.

>> +                       strcpy(nt->np.dev_name, dev->name);
> 
> ... you'll have move this up.
> 

Why? I don't have opposition about moving this up, but I'm misplacing the abobe code?
or it isn't appropriate about coding style?

Thanks
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com



