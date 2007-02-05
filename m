Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbXBERyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbXBERyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbXBERyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:54:39 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:26972 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbXBERyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:54:38 -0500
In-Reply-To: <Pine.LNX.4.64.0702032112220.16929@alien.or.mcafeemobile.com>
References: <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <Pine.LNX.4.64.0702032112220.16929@alien.or.mcafeemobile.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4F91342C-7AEE-4729-A5B7-BED4A2B8278E@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Mon, 5 Feb 2007 12:54:17 -0500
To: Davide Libenzi <davidel@xmailserver.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
>
>> +	current->per_call = next->per_call;
>
> Pointer instead of structure copy?

Sure, there are lots of trade-offs there, but the story changes if we  
keep the 1:1 relationship between task_struct and thread_info.

- z
