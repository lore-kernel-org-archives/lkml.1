Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYHSKg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYHSKg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbYHSKgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:36:17 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:60587 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751718AbYHSKgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:36:16 -0400
Message-ID: <48AAA217.8040307@linux.vnet.ibm.com>
Date: Tue, 19 Aug 2008 16:06:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm_owner: fix cgroup null dereference
References: <1218745013-9537-1-git-send-email-jirislaby@gmail.com> <48A49C78.7070100@linux.vnet.ibm.com> <48A9E82E.3060009@gmail.com> <48AA4003.5080300@linux.vnet.ibm.com> <48AA970D.5050403@gmail.com>
In-Reply-To: <48AA970D.5050403@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 08/19/2008 05:37 AM, Balbir Singh wrote:
>> Could you please help me with the steps to reproduce the problem.  I don't seem
>> to be hitting the mm->owner changed callback. I did have a test case for it when
>> I developed mm->owner functionality, but it does not trigger an oops for me.
> 
> I have no idea. My config is at:
> http://decibel.fi.muni.cz/~xslaby/config-memrlimit-oops
> I don't play with cgroups or anything, I just work on the system. Do you need a
> test case, it's obvious from the code as far as I can see?

Yes, the problem is obvious, but I usually use small test cases or test
scenarios to verify that the problem is fixed.

-- 
	Balbir
