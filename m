Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbYFUIGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbYFUIGU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 04:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYFUIF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 04:05:57 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:51234 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751147AbYFUIFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:05:54 -0400
Message-ID: <485CB652.90801@linux.vnet.ibm.com>
Date: Sat, 21 Jun 2008 13:35:38 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Priority heap infrastructure enhancements
References: <1213796886-24863-1-git-send-email-balbir@linux.vnet.ibm.com> <6599ad830806210029x2a020e1ava6b646be9913fcdf@mail.gmail.com>
In-Reply-To: <6599ad830806210029x2a020e1ava6b646be9913fcdf@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Jun 18, 2008 at 6:48 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> Some of the common code has been factored into heap_adjust() a.k.a heapify
>> in data structures terminology.
>>
>> I am sending out this  patch indepedent of the memory controller changes as
>> they deserve to be reviewed independently.
>>
>> One limitation of the current heap_insert() routine is that it does not
>> insert an element which is greater than the root, when the heap slots
>> are fully used. I'll work on and review that interface and find a suitable
>> way to address that issue
> 
> How else would you want it to behave? If you have a fixed size heap
> and it's full, then you have to drop the largest value. (Well, you
> could in theory drop the smallest value, but there's no quick way to
> find that.)
> 

I would like to be able to drop the smallest value. Since we cannot drop the
smallest value, dropping a leaf (heap->size) should be sufficiently good enough.
I want a max heap and losing the root of the heap does not work for me.


>> Comments, Flames? Please do review closely!
>>
>> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Looks fine.
> 
> Reviewed-by: Paul Menage <menage@google.com>

Thanks for the review!

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
