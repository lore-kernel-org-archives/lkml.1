Return-Path: <linux-kernel-owner+w=401wt.eu-S1761075AbYJMN1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075AbYJMN1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755380AbYJMN10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:27:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45688 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192AbYJMN1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:27:25 -0400
Message-ID: <48F34CB9.3020000@pobox.com>
Date: Mon, 13 Oct 2008 09:27:21 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_of_platform: fix no irq handling
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru> <48F2F138.6020103@kernel.org>
In-Reply-To: <48F2F138.6020103@kernel.org>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Anton Vorontsov wrote:
>> When no irq specified the pata_of_platform fills the irq_res with -1,
>> which is wrong to do for two reasons:
>>
>> 1. By definition, 'no irq' should be IRQ 0, not some negative integer;
>> 2. pata_platform checks for irq_res.start > 0, but since irq_res.start
>>    is unsigned type, the check will be true for `-1'.
>>
>> Reported-by: Steven A. Falco <sfalco@harris.com>
>> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> 
> applied to #tj-upstream (will soon be sent upstream)

I have returned!  muhahahahahaha....


