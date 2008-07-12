Return-Path: <linux-kernel-owner+w=401wt.eu-S1751854AbYGLHZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751854AbYGLHZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 03:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbYGLHYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 03:24:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52428 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbYGLHYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 03:24:51 -0400
Date: Sat, 12 Jul 2008 16:15:55 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.26-rc8-mm1 - sleeping function called from invalid context at include/linux/pagemap.h:291
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <48737CBE.4010301@linux.vnet.ibm.com>
References: <20080703020236.adaa51fa.akpm@linux-foundation.org> <48737CBE.4010301@linux.vnet.ibm.com>
Message-Id: <20080712161058.F6A5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamalesh,

> Hi Andrew,
> 
> While booting up and shutting down, x86 machine with 2.6.26-rc8-mm1 kernel,
> kernel bug call trace is shows up in the logs

That is known bug.
please turn off CONFIG_UNEVICTABLE_LRU.

and see below thread.

	[-mm] BUG: sleeping function called from invalid context at include/linux/pagemap.h:290





