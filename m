Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbZETWw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbZETWw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 18:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbZETWwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 18:52:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33608
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836AbZETWwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 18:52:50 -0400
Date: Wed, 20 May 2009 15:52:48 -0700 (PDT)
Message-Id: <20090520.155248.03355490.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk,
       hskinnemoen@atmel.com
Subject: Re: Subject: [PATCH] Sort out syscall_restart name clash.
From: David Miller <davem@davemloft.net>
In-Reply-To: <m1k54bie6j.fsf_-_@fess.ebiederm.org>
References: <m1d4a3keqm.fsf@fess.ebiederm.org>
	<20090520.124403.159818618.davem@davemloft.net>
	<m1k54bie6j.fsf_-_@fess.ebiederm.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 20 May 2009 15:48:20 -0700

> 
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
> 
>> Today's linux-next build of at least some av32 and arm configs failed like this:
>>
>> arch/avr32/kernel/signal.c:216: error: conflicting types for 'restart_syscall'
>> include/linux/sched.h:2184: error: previous definition of 'restart_syscall' was here
>>
>> Caused by commit 690cc3ffe33ac4a2857583c22d4c6244ae11684d ("syscall:
>> Implement a convinience function restart_syscall") from the net tree.
> 
> Grrr. Some days it feels like all of the good names are already taken.
> 
> Let's just rename the two static users in arm and avr32 to get this
> sorted out.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Applied, thanks Eric.
