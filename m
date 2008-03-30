Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbYC3EKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbYC3EKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 00:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbYC3EKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 00:10:13 -0400
Received: from barikada.upol.cz ([158.194.242.200]:35959 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYC3EKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 00:10:12 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Joern Engel <joern@logfs.org>,
       David Miller <davem@davemloft.net>, jirislaby@gmail.com,
       joe@perches.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: style of function definitions (Re: [patch] bkl2mtd: cleanup)
In-Reply-To: <20080326111021.GF17176@elte.hu>
References: <20080323.051929.267232495.davem@davemloft.net> <20080325104841.GA24211@elte.hu> <20080325111129.GB11359@logfs.org> <20080325122413.GA8729@elte.hu> <20080325131258.GC11359@logfs.org> <20080325133810.GA10044@elte.hu> <20080325134556.GA10424@elte.hu> <20080325160734.GA14583@logfs.org> <20080326101452.GA17176@elte.hu> <20080326104821.GS10722@ZenIV.linux.org.uk> <20080326111021.GF17176@elte.hu>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Sun, 30 Mar 2008 06:29:52 +0200
Message-Id: <E1JfpB2-00036u-2G@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar @ Wed, 26 Mar 2008 12:10:21 +0100
>
> * Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
[]
>> > -static int block2mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
>> > +static int
>> > +block2mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
>> >  		size_t *retlen, const u_char *buf)
>> 
>> Again, why split it that way?
>
> these are really nuances, so unless you are interested in such nuances 
> nowhere found in CodingStyle, stop reading here :-)

Nuances, or not, there are all kinds of stuff in Linux. Very small
journey from simple `grep` and trivial multi-line `sed` to a huge
discovery can be found here:

http://kernelnewbies.org/olecom#Function_definitions

No matter what coding style is, the winner is "linux-2.6/fs/xfs", and
i doubt anyone can fix that :)

Maybe meta-patching by `sed` scripts in `git`? Just kidding.
--
-o--=O`C
 #oo'L O
<___=E M
