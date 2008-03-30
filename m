Return-Path: <linux-kernel-owner+w=401wt.eu-S1751666AbYC3Fbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbYC3Fbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 01:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYC3Fbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 01:31:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35319 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYC3Fbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 01:31:32 -0400
Date: Sun, 30 Mar 2008 07:31:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       Joern Engel <joern@logfs.org>, David Miller <davem@davemloft.net>,
       jirislaby@gmail.com, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: style of function definitions (Re: [patch] bkl2mtd: cleanup)
In-Reply-To: <E1JfpB2-00036u-2G@flower>
Message-ID: <alpine.LNX.1.10.0803300727120.28605@fbirervta.pbzchgretzou.qr>
References: <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu>
 <20080325160734.GA14583@logfs.org> <20080326101452.GA17176@elte.hu> <20080326104821.GS10722@ZenIV.linux.org.uk> <20080326111021.GF17176@elte.hu> <E1JfpB2-00036u-2G@flower>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2008-03-30 06:29, Oleg Verych wrote:
> []
>>>> -static int block2mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
>>>> +static int
>>>> +block2mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
>>>>  		size_t *retlen, const u_char *buf)
>>>
>>> Again, why split it that way?
>>
>> these are really nuances, so unless you are interested in such nuances
>> nowhere found in CodingStyle, stop reading here :-)
>
> Nuances, or not, there are all kinds of stuff in Linux. Very small
> journey from simple `grep` and trivial multi-line `sed` to a huge
> discovery can be found here:
>
> http://kernelnewbies.org/olecom#Function_definitions
>
> No matter what coding style is, the winner is "linux-2.6/fs/xfs", and
> i doubt anyone can fix that :)

They at least have an excuse of having a historical unix background :)
