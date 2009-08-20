Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZHTKDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZHTKDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbZHTKDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:03:17 -0400
Received: from www84.your-server.de ([213.133.104.84]:58057 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbZHTKDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:03:16 -0400
Message-ID: <20090820120310.19332j54j4mf7rry@mail.your-server.de>
Date: Thu, 20 Aug 2009 12:03:10 +0200
From: stefani@seibold.net
To: David Vrabel <david.vrabel@csr.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 4/7] kfifo: rename kfifo_put... into kfifo_in... and
 kfifo_get... into kfifo_out...
References: <1250714990.13476.3.camel@wall-e>
 <1250715606.13476.15.camel@wall-e>
 <1250715819.3407.88.camel@Joe-Laptop.home> <4A8D1E2E.1010006@csr.com>
In-Reply-To: <4A8D1E2E.1010006@csr.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.2)
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zitat von David Vrabel <david.vrabel@csr.com>:

> Joe Perches wrote:
>> On Wed, 2009-08-19 at 23:00 +0200, Stefani Seibold wrote:
>>> rename kfifo_put... into kfifo_in... to prevent miss use of old  
>>> non in kernel-tree drivers
>>> ditto for kfifo_get... -> kfifo_out...
>>
>> I would have thought
>> 	kfifo_put -> kfifo_out
>> 	kfifo_get -> kfifo_in
>> but maybe that's just me.
>
> Use push and pull instead?  In and out (whichever way) isn't obvious enough.
>
> David
>

As i wrote before: FIFO means first in/first out not first  
pushed/first pulled nor first put/first get
It it logical.

