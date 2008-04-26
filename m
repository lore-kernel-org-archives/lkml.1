Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYDZPak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYDZPak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYDZPab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:30:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35696 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYDZPab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:30:31 -0400
Date: Sat, 26 Apr 2008 17:30:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jason Wessel <jason.wessel@windriver.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb over ethernet?
In-Reply-To: <481215B7.9020503@windriver.com>
Message-ID: <alpine.LNX.1.10.0804261729140.20150@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804251837410.20150@fbirervta.pbzchgretzou.qr> <481215B7.9020503@windriver.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-04-25 19:32, Jason Wessel wrote:
>Jan Engelhardt wrote:
>>
>> the DocBook files for the recently-merged kgdb mention kgdboe, as does 
>> the doc on kgdb.sf.net, but I do not see kgdboe anywhere in the source. 
>> Is oe actually merged? I'm kinda short on rs232...
>
>Well if you have at least one you have enough because you can share kgdb
>with the console.

kgdb is running, though I wonder why breakpoints are not seemingly hit.

(gdb) b vfs_readdir
cBreakpoint 2 at 0xc0270c11: file fs/readdir.c, line 23.
(gdb) c
Continuing.

Then I issued ls -l on tty1 (kgdb is on ttyS0), but it did not
happen to stop at vfs_readdir, though I would assume vfs_readdir
was entered as part of /bin/ls.
Ideas?
