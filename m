Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXGHGCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXGHGCu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 02:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbXGHGCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 02:02:41 -0400
Received: from main.gmane.org ([80.91.229.2]:51059 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbXGHGCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 02:02:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: Coding style on function signatures  (was: Convert tasklets to work queues )
Date: Sun, 8 Jul 2007 06:02:26 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnf91089.bju.olecom@flower.upol.cz>
References: <20070622182051.859570787@goodmis.org> <20070622182315.571740041@goodmis.org> <20070623095359.4667514e.akpm@linux-foundation.org> <alpine.LFD.0.98.0706231113200.3593@woody.linux-foundation.org> <20070623115252.fc36f20c.rdunlap@xenotime.net> <alpine.LFD.0.98.0706231209130.3593@woody.linux-foundation.org> <46903483.3020205@gmail.com> <20070707213753.7480ccca.rdunlap@xenotime.net>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
X-User-Agent: jed (x86_64-pc-linux-glibc-debian)
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> static ssize_t
>> store_fan_div (struct device *dev, struct device_attribute *devattr,
>>                     const char *buf, size_t count)
>> {...}
>> 
>> 
>> IIRC, many like the entire sig on one line, because its grep friendly.
>> I personally like the above, but grep-ability is hard to argue against.
>
> (I expect that "you" above means Linus, but anyway...)
>
> Some people like the above so that the function name can be grepped
> using a "^store_fan_div" regex, but that's not good enough reason
> for it for others, including Linus, IIRC.

Right. I was reading some LKML archives, and what i know, that returning
type of the function is the first thing Linus cared about.

Newbies homework to think why (and care more about such things and not
of the look).

--
-o--=O`C
 #oo'L O
<___=E M

