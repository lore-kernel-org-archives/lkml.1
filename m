Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbYI0RjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbYI0RjA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 13:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYI0Rik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 13:38:40 -0400
Received: from mail.tmr.com ([64.65.253.246]:37354 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbYI0Rij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 13:38:39 -0400
Message-ID: <48DE6F93.9030002@tmr.com>
Date: Sat, 27 Sep 2008 13:38:27 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080716 Fedora/1.1.11-1.fc9 SeaMonkey/1.1.11
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Swap on loop device on tmpfs locks up machine
References: <19f34abd0809261146j72a68765i964466336a3a34dc@mail.gmail.com> <48DE2BF7.3060905@davidnewall.com>
In-Reply-To: <48DE2BF7.3060905@davidnewall.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Vegard Nossum wrote:
>> It turns out that swap over loop device on tmpfs will lock up the
>> machine.
> 
> Doesn't tmpfs use otherwise-free virtual memory?  I expect the machine
> would lock up if you put swap (i.e. additional virtual memory) on such a
> device.

To reinstate the paragraph from the O.P. you snipped:
 >> I'm not sure it's really a very good idea to do this in the first
 >> place, but should something give a warning or prevent a user from
 >> doing it?

I think you are both right, it is a bad thing to do, it does seem to lock up, 
and something should prevent a user from doing that. But it may be easier to fix 
the lockup than get the "prevent" right, there appears to be a loop there.

Just a simple questions to the O.P.: what were you thinking?!! Or was this a 
test just to see what would happen?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
