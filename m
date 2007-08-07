Return-Path: <linux-kernel-owner+w=401wt.eu-S934883AbXHGQQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883AbXHGQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 12:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758639AbXHGQQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 12:16:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48671 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216AbXHGQQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 12:16:21 -0400
Date: Tue, 7 Aug 2007 18:16:20 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joe Perches <joe@perches.com>
cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, adaplas@pol.net,
       greg@kroah.com, jeff@garzik.org
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
 added to -mm tree
In-Reply-To: <1186503016.5983.20.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708071815280.26397@fbirervta.pbzchgretzou.qr>
References: <0H03p0ll.1186246070.5043630.khali@localhost>
 <1186503016.5983.20.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 7 2007 09:10, Joe Perches wrote:
>On Sat, 2007-08-04 at 18:47 +0200, Jean Delvare wrote:
>> On 8/4/2007, "Jan Engelhardt" <jengelh@computergmbh.de> wrote: 
>> >Ugh. What do we have printk for then? I do not like this.
>> >For pr_debug() it makes sense because its semantics change with
>> >-DDEBUG and -UDEBUG, but for these pr_()s it does not seem so.
>> I think I agree with Jan here, I see no fundamental need for these
>> additional macros. But if they are really added, then they should follow
>> the same standard as pr_debug() and pr_info(), that is: no "\n" added
>> automatically. Otherwise this will become quite messy.
>
>2 reasons:
>
>This change will eventually isolate multiple line
>printk messages and allow easier insertion of 
>
>printk_block_start
>printks
>printk_block_end
>
>so that multiple line messages are kept together in the message logs.

They are not kept together today, so I do not see how that will change.
Locking the printk buffer between _start and _end? No thanks, I don't
have overlapping messages that often.

Or what is it actually that you are trying to accomplish?


	Jan
-- 
