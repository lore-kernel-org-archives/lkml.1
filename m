Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYAHWsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYAHWsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYAHWrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:47:53 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:20918 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbYAHWrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:47:52 -0500
Message-ID: <4783FD17.90806@oracle.com>
Date: Tue, 08 Jan 2008 14:45:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7: sparc64: WARNING: at kernel/lockdep_proc.c:267
 lockdep_stats_show()
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801081942.17139.m.kozlowski@tuxland.pl> <20080108130034.8ab82fb0.randy.dunlap@oracle.com> <200801082339.13198.m.kozlowski@tuxland.pl>
In-Reply-To: <200801082339.13198.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
> Hello, 
> 
>>> 	Got this when doing usual looping over /proc entries on fresh test kernel:
>> What is the usual looping, please?
> 
> #!/bin/bash
> 
> for i in `find /proc -type f`; do
>         echo -n "cat $i > /dev/null ... ";
>         ( cat $i > /dev/null & );
>         echo "done";
> done

OK, thanks.  Probably not related to the problem report, but
the script should probably check each file for 'readable' (-r).
/proc/sysrq-trigger is write-only...

-- 
~Randy
