Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab0BLO2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 09:28:53 -0500
Received: from mika.eatserver.nl ([195.20.9.75]:54373 "EHLO mika.eatserver.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab0BLO2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 09:28:51 -0500
X-Greylist: delayed 2594 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2010 09:28:51 EST
X-Spam-CTCH-RefID: 
Message-ID: <4B755B72.9060805@aimvalley.nl>
Date: Fri, 12 Feb 2010 14:45:22 +0100
From: Norbert van Bolhuis <nvbolhuis@aimvalley.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Kevin Cernekee <kpc.mtd@gmail.com>, linux-mtd@lists.infradead.org,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] MTD: Add UBI reboot notifier
References: <1244550775.5847.385.camel@localhost.localdomain>	<f5be75d5abc1acd236bedf36c55a860e@localhost> <1265980392.29027.12.camel@localhost>
In-Reply-To: <1265980392.29027.12.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> FYI, I do not like this patch, because it is not solving the problem, it
> just makes the problem less likely. I.e., you are still screwed if you
> reboot while some other task is doing erasure. Indeed, the background
> thread is not the only task which may do erases.
> 
> I'm not going to revert this patch, but wanted to let you know that I
> think it was my mistake to push it.
> 

so, how to solve this properly ?

probably the only way is the reboot notifier of the MTD chip driver
(for NOR flash only cmdset_0001 has one).

