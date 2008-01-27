Return-Path: <linux-kernel-owner+w=401wt.eu-S1750882AbYA0Q5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750882AbYA0Q5w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 11:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYA0Q5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 11:57:41 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:10579 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbYA0Q5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 11:57:40 -0500
Message-ID: <479CB5A8.9050405@oracle.com>
Date: Sun, 27 Jan 2008 08:47:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Konrad Rzeszutek <konrad@darnok.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com, dwm@enoyolf.org, darnok@68k.org, pjones@redhat.com,
       konradr@redhat.com, konradr@linux.vnet.ibm.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org, michaelc@cs.wisc.edu,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.5)
References: <20080125220629.GA25325@andromeda.dapyr.net> <20080126220123.d20dd393.akpm@linux-foundation.org>
In-Reply-To: <20080126220123.d20dd393.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>>  int __initdata user_defined_memmap = 0;

> checkpatch should have told you that this "= 0" shouldn't be there.  But it
> doesn't.


checkpatch checks for static initializers, not non-static ones.
Should that be changed?



>> +	for (pos = (u8 *)hdr; pos < (u8 *)hdr + len; pos ++)
>>
> 
> checkpatch should have caught the " ++" but didn't.  I think it used to. 
> It seems to be going backwards?


-- 
~Randy
