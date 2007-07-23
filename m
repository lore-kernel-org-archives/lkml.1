Return-Path: <linux-kernel-owner+w=401wt.eu-S933537AbXGWUIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbXGWUIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 16:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934400AbXGWUHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 16:07:45 -0400
Received: from mail.tmr.com ([64.65.253.246]:46268 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934330AbXGWUHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 16:07:43 -0400
Message-ID: <46A50AD6.6050806@tmr.com>
Date: Mon, 23 Jul 2007 16:08:54 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Al Boldi <a1426z@gawab.com>
CC: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFH] Partion table recovery
References: <200707200813.03553.a1426z@gawab.com>
In-Reply-To: <200707200813.03553.a1426z@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Boldi wrote:
> As always, a good friend of mine managed to scratch my partion table by 
> cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but 
> at least the first 100MB are gone.  I can probably live without the first 
> partion, but there are many partitions after that, which I hope should 
> easily be recoverable.
>
> I tried parted, but it's not working out for me.  Does anybody know of a 
> simple partition recovery tool, that would just scan the disk for lost 
> partions?
>   
You have gotten a bunch of thoughts on this, I will just say that plain 
old "fdisk -l" saved somewhere safe is probably all you need, in human 
readable format. Doesn't do you any good now, but all the complicated 
schemes discussed don't thrill me, I want to be able to see this, and 
recovery by partition table manual rebuild is so rare I would rather do 
it by hand than trust some software I rarely use.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

