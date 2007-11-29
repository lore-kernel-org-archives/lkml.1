Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbXK2K3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbXK2K3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758847AbXK2K3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:29:06 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:25833 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbXK2K3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:29:02 -0500
Message-ID: <474E944C.4020809@fr.ibm.com>
Date: Thu, 29 Nov 2007 11:28:28 +0100
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch -mm 2/4] mqueue namespace : add unshare support
References: <20071128163728.177495768@fr.ibm.com>> <20071128164349.196734045@fr.ibm.com>> <474DA61B.5030301@openvz.org>
In-Reply-To: <474DA61B.5030301@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Index: 2.6.24-rc3-mm2/include/linux/sched.h
>> ===================================================================
>> --- 2.6.24-rc3-mm2.orig/include/linux/sched.h
>> +++ 2.6.24-rc3-mm2/include/linux/sched.h
>> @@ -27,6 +27,7 @@
>>  #define CLONE_NEWUSER		0x10000000	/* New user namespace */
>>  #define CLONE_NEWPID		0x20000000	/* New pid namespace */
>>  #define CLONE_NEWNET		0x40000000	/* New network namespace */
>> +#define CLONE_NEWMQ		0x80000000	/* New posix mqueue namespace */
> 
> That's it :) We've run out of clone flags on 32-bit platforms :(

yes. 

I have been giving some thoughts to a clone2() to extend the flags but
andrew is preparing to recycle CLONE_DETACHED and CLONE_STOPPED for
2.6.26. Some we might have some more time in front of us.

C.
