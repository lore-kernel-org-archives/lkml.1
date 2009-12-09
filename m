Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZLIByz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZLIByz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 20:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbZLIByu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 20:54:50 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36965 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbZLIByt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 20:54:49 -0500
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091205.193505.193701079.davem@davemloft.net>
	<20091208194530.GA24530@elte.hu>
	<20091208.125032.70743046.davem@davemloft.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 08 Dec 2009 17:54:47 -0800
In-Reply-To: <20091208.125032.70743046.davem@davemloft.net> (David Miller's message of "Tue\, 08 Dec 2009 12\:50\:32 -0800 \(PST\)")
Message-ID: <m1ein4zzbs.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [GIT]: Networking
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 8 Dec 2009 20:45:30 +0100
>
>> i just switched to today's -git tree and there's this new build failure 
>> on x86:
>> 
>>  net/sctp/sysctl.c:251: error: unknown field 'strategy' specified in initializer
>>  net/sctp/sysctl.c:251: error: 'sysctl_intvec' undeclared here (not in a function)
>> 
>> havent looked into it yet - config attached.
>
> It's probably a conflict with Eric Beiderman's sysctl cleanups that
> got merged in at the same time.

Yep. You guys figured it out.  Thanks all.

I have looked and I don't see any more .ctl_name or .strategy fields
left in the kernel so this should be the last of it.

Hooray!  Maintenance of binary sysctl is gone!

Eric
