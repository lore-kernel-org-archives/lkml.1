Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYERDjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYERDjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 23:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751420AbYERDja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 23:39:30 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37143 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYERDj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 23:39:29 -0400
To: Joe Eykholt <jre@nuovasystems.com>
cc: Nicolas 2P <nicolas.2p.debian@free.fr>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       linux-net@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [Bonding-devel] [patch] bondig - arp_interval with low value => Oops. 
In-reply-to: <482F3DF6.7080403@nuovasystems.com> 
References: <482C9E73.2040202@free.fr> <482F3DF6.7080403@nuovasystems.com>
Comments: In-reply-to Joe Eykholt <jre@nuovasystems.com>
   message dated "Sat, 17 May 2008 13:20:06 -0700."
X-Mailer: MH-E 8.0.3; nmh 1.1-RC4; GNU Emacs 22.0.95
Date: Sat, 17 May 2008 20:39:20 -0700
Message-ID: <5888.1211081960@death>
From: Jay Vosburgh <fubar@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Eykholt <jre@nuovasystems.com> wrote:

>Nicolas 2P wrote:
[...]
>> @@ -2837,7 +2837,7 @@
>> 
>>         read_lock(&bond->lock);
>> 
>> -       delta_in_ticks = (bond->params.arp_interval * HZ) / 1000;
>> +       delta_in_ticks = msecs_to_jiffies(bond->params.arp_interval * HZ);
>
>This seems like it should be just:
>
>	delta_in_ticks = msecs_to_jiffies(bond->params.arp_interval);

	Yes.  I've corrected this already in my copy (which I'll be
posting momentarily).

>Same for the other changes?

	The other two instances were correct, only the last change had
the extra "* HZ".

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
