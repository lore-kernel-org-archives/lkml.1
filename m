Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbYJULzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbYJULzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 07:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYJULy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 07:54:59 -0400
Received: from [202.71.129.41] ([202.71.129.41]:41262 "EHLO
	smtpauth.net4india.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752282AbYJULy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 07:54:58 -0400
Message-ID: <48FDC26D.80104@xenontk.org>
Date: Tue, 21 Oct 2008 17:22:13 +0530
From: David John <davidjon@xenontk.org>
Reply-To: davidjon@xenontk.org
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       tglx@linutronix.de, andi@firstfloor.org
Subject: Re: [PATCH v5] HPET: Remove the BKL.
References: <1224568707-2361-1-git-send-email-davidjon@xenontk.org> <20081021113456.GA14529@elte.hu>
In-Reply-To: <20081021113456.GA14529@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * David John <davidjon@xenontk.org> wrote:
> 
>> Remove calls to the BKL as concurrent access is protected
>> by the spinlock hpet_lock.
>>
>> Signed-off-by: David John <davidjon@xenontk.org>
>> ---
>>  drivers/char/hpet.c |   41 ++++++++++++++++++++++++-----------------
>>  1 files changed, 24 insertions(+), 17 deletions(-)
> 
> this patch still needs to add locking documentation commits to hpet.c, 
> which shows that you considered all the locking changes that happen due 
> to dropping the BKL. Most of this code runs very rarely so there's 
> little chance that races will be caught in practice in any debuggable 
> manner.
> 
> 	Ingo
> 

Ok, will do this. Can you also check the RTC patch I sent that removes
the BKL from the RTC user space driver? The locking is already done,
only the BKL calls needed to be removed.

David.
