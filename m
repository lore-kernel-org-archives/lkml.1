Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbXLEWbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbXLEWbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 17:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbXLEWbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 17:31:31 -0500
Received: from rtr.ca ([76.10.145.34]:3682 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbXLEWba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 17:31:30 -0500
Message-ID: <475726C0.9060803@rtr.ca>
Date: Wed, 05 Dec 2007 17:31:28 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Radoslaw Szkodzinski <lkml@astralstorm.puszkin.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
References: <20071202185945.GA25990@elte.hu>	<20071202114152.3bf4332d@laptopd505.fenrus.org>	<20071202200953.GA23994@one.firstfloor.org>	<20071202202602.GA16480@elte.hu>	<20071202204725.GA25891@one.firstfloor.org>	<20071202144331.6abf1289@laptopd505.fenrus.org>	<20071203000741.GB26636@one.firstfloor.org>	<20071202165913.3eaebee6@laptopd505.fenrus.org>	<20071203095501.GB28560@one.firstfloor.org>	<20071203111520.33ed2139@astralstorm.puszkin.org>	<20071203102715.GC28560@one.firstfloor.org> <20071203072328.371d0b00@laptopd505.fenrus.org>
In-Reply-To: <20071203072328.371d0b00@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 3 Dec 2007 11:27:15 +0100
> Andi Kleen <andi@firstfloor.org> wrote:
> 
>>> Kernel waiting 2 minutes on TASK_UNINTERRUPTIBLE is certainly
>>> broken.
>> What should it do when the NFS server doesn't answer anymore or 
>> when the network to the SAN RAID array located a few hundred KM away
>> develops some hickup?  Or just the SCSI driver decides to do lengthy
>> error recovery  -- you could argue that is broken if it takes longer 
>> than 2 minutes, but in practice these things are hard to test
>> and to fix.
>>
> 
> the scsi layer will have the IO totally aborted within that time anyway;
> the retry timeout for disks is 30 seconds after all.
..

Mmm.. but the SCSI layer may do many retries, each with 30sec timeouts..
