Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYDFFj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYDFFj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 01:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYDFFjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 01:39:20 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:45758 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYDFFjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 01:39:19 -0400
Message-ID: <47F861C8.7080700@linux.vnet.ibm.com>
Date: Sun, 06 Apr 2008 11:08:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Pavel Emelianov <xemul@openvz.org>, Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain> <47F5E69C.9@linux.vnet.ibm.com> <6599ad830804040150j4946cf92h886bb26000319f3b@mail.gmail.com> <47F5F3FA.7060709@linux.vnet.ibm.com> <6599ad830804041211r37848a6coaa900d8bdac40fbe@mail.gmail.com> <47F79102.6090406@linux.vnet.ibm.com> <6599ad830804051023v69caa3d4h6e26ccb420bca899@mail.gmail.com> <47F7BB69.3000502@linux.vnet.ibm.com> <6599ad830804051057n2f2802e4w6179f2e108467494@mail.gmail.com> <47F7CC08.4090209@linux.vnet.ibm.com> <6599ad830804051629k3649dbc4na92bb3d0cd7a0492@mail.gmail.com>
In-Reply-To: <6599ad830804051629k3649dbc4na92bb3d0cd7a0492@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Sat, Apr 5, 2008 at 11:59 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>  > But surely the performance of thread exits wouldn't be affected by the
>>  > delay_group_leader(p) change, since none of the exiting threads would
>>  > be a group leader. That optimization only matters when the entire
>>  > process exits.
>>  >
>>
>>  On the client side, each JVM instance exits after the test. I see the thread
>>  group leader exit as well through getdelays (I see TGID exits).
> 
> How long does the test run for? How many threads does each client have?

The test on each client side runs for about 10 seconds. I saw the client create
up to 411 threads.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
