Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbZCXJzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbZCXJzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZCXJy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:54:59 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27966 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbZCXJy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:54:59 -0400
Message-ID: <49C8ADEE.3000606@gmail.com>
Date: Tue, 24 Mar 2009 12:54:54 +0300
From: Stanichenko Marat <mstanichenko@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work properly
 in bridge
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Thu, Mar 19, 2009 at 11:21:43AM CET, davem@davemloft.net wrote:
>>From: Jiri Pirko <jpirko@redhat.com>
>>Date: Thu, 19 Mar 2009 09:44:45 +0100
>>
>>> Yes I was looking at this thing yesterday (uc_list). But this list serves
>>> to different purpose. Do you think that it will be correct to use it for this? I
>>> would maybe like to make a new list similar to this for our purpose
>>> (say addr_list). I think it would be more correct.
>>
>>Whatever you do with that list privately inside of the bonding
>>driver should be fine.
> Well I do not need it only inside the bonding driver. I want bridge to use this
> list when adding a device in it and get mac addresses from there into its
> hashlist (to recognize these addresses as local).
Please correct me if I understand you improperly. You're going to mark all mac 
addresses that belong to slaves as "local" when adding a bond device to the 
bridge, aren't you? The only thing I'd like to notice (this might be an obvious 
one): a packet that is pushed out from one slave might reach the host through 
another slave. Considering all slaves as "local" in bridge code might lead to 
numerous messages "received packet with own address as source address".

Please CC me personally when answering this message.

Thanks,
Marat.
