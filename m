Return-Path: <linux-kernel-owner+w=401wt.eu-S1751641AbXFKLLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbXFKLLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 07:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXFKLLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 07:11:38 -0400
Received: from max.aladin.ro ([80.96.155.2]:60009 "EHLO aladin.ro"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXFKLLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 07:11:38 -0400
Message-ID: <466D2DF7.9020709@aladin.ro>
Date: Mon, 11 Jun 2007 14:11:51 +0300
From: Eduard-Gabriel Munteanu <maxdamage@aladin.ro>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: DervishD <lkml@dervishd.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: ext2 on flash memory
References: <20070611101319.GA14284@DervishD>
In-Reply-To: <20070611101319.GA14284@DervishD>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

*This message was transferred with a trial version of CommuniGate(r) Pro*
DervishD wrote:
> *This message was transferred with a trial version of CommuniGate(r) Pro*
> *This message was transferred with a trial version of CommuniGate(r) Pro*
>     Hi all :)
> 
>     I was wondering: is there any reason not to use ext2 on an USB
> pendrive? Really my question is not only about USB pendrives, but any
> device whose storage is flash based. Let's assume that the device has a
> good quality flash memory with wear leveling and the like...
> 
>     Thanks a lot in advance :)
> 
>     Raúl Núñez de Arenas Coronado
> 

Your USB pendrive will wear faster if you use an inappropriate 
filesystem. Such filesystems require frequent writes and change their 
internal state often.

This could be alleviated by COWing the filesystem somehow and flushing 
writes when you're finished. But the modifications will be lost if 
crashes occur. The filesystem structures will still change a lot and 
require  big writes to update it.

Really, why don't you try a more suitable fs for your pendrive, one that 
changes itself less than usual fs's?

