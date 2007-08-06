Return-Path: <linux-kernel-owner+w=401wt.eu-S1765851AbXHFUoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765851AbXHFUoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 16:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761877AbXHFUoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 16:44:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:34654 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084AbXHFUoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 16:44:11 -0400
Message-ID: <46B78814.50508@pobox.com>
Date: Mon, 06 Aug 2007 16:44:04 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: brking@linux.vnet.ibm.com
CC: Mariusz Kozlowski <m.kozlowski@tuxland.pl>, santil@us.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/ibmveth.c: memset fix
References: <200708062217.04361.m.kozlowski@tuxland.pl> <46B78672.9090808@linux.vnet.ibm.com>
In-Reply-To: <46B78672.9090808@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.1 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.1 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Brian King wrote:
> Mariusz Kozlowski wrote:
>> Hello,
>>
>> 	Looks like memset() is zeroing wrong nr of bytes.
> 
> Good catch, however, I think we can just remove this memset altogether
> since the memory gets allocated via kzalloc.

Correct, that memset() is superfluous.

	Jeff



