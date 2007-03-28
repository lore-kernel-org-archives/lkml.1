Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbXC1QdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbXC1QdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 12:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbXC1QdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 12:33:18 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48776 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbXC1QdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 12:33:17 -0400
Message-ID: <460A98B9.9040602@zytor.com>
Date: Wed, 28 Mar 2007 09:32:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Paul Sokolovsky <pmiscml@gmail.com>
CC: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       Anton Vorontsov <cbou@mail.ru>
Subject: Re: [RFC] Virtual methods for devices and generalized GPIO support
 using it
References: <881020209.20070327113610@gmail.com>
In-Reply-To: <881020209.20070327113610@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Sokolovsky wrote:
> 
> In this respect, VTABLE(), METHOD() macros serve the same purpose as 
> container_of() and list_for_each() - they are besides offering (more) 
> convenient syntax, also carry important annotattion and educational
> messages, like "it's ok, and encouraged to embed one structure into 
> another - use it!" or "list manipulation is a trivial operation for kernel,
> and we want you to treat it as such and use in standard, easily 
> distinguishable way".
> 

You realize, right, that the Linux kernel already have a much cleaner 
way to do vtables in the kernel, without this kind of macro crappage? 
It's called an _ops table, and is used in a patternized way:

foo->x_ops->func(foo, ...);

... all over the kernel.  We like it that way.

	-hpa
