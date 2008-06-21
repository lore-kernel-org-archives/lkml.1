Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbYFUIye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbYFUIye (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYFUIy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:54:26 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:50413 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYFUIyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:54:25 -0400
Message-ID: <485CC1AF.5060901@linux.vnet.ibm.com>
Date: Sat, 21 Jun 2008 14:24:07 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Priority heap infrastructure enhancements
References: <1213796886-24863-1-git-send-email-balbir@linux.vnet.ibm.com> <6599ad830806210029x2a020e1ava6b646be9913fcdf@mail.gmail.com> <485CB652.90801@linux.vnet.ibm.com> <6599ad830806210111o41ad8526j8490662ddf35f299@mail.gmail.com>
In-Reply-To: <6599ad830806210111o41ad8526j8490662ddf35f299@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Sat, Jun 21, 2008 at 1:05 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> I would like to be able to drop the smallest value. Since we cannot drop the
>> smallest value, dropping a leaf (heap->size) should be sufficiently good enough.
>> I want a max heap and losing the root of the heap does not work for me.
>>
> 
> What are you actually trying to do? Can you get round this by just
> inverting your "gt" operator? i.e. provide one that actually
> implements "less-than"?

Paul,

That would convert the entire heap to a min-heap. With my soft limit patches,
that I am working on for the memory controller; I want the controller that has
exceeded it's soft limit by the maximum amount to be picked off the heap, so
that we can reclaim from it on memory contention.

Ideally, I would also like to be able to find an existing node in the heap, but
that is hard. I can work around that problem for now.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
