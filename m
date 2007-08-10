Return-Path: <linux-kernel-owner+w=401wt.eu-S939915AbXHJQBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939915AbXHJQBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933475AbXHJQBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:01:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:47013 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760AbXHJQBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:01:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.23-rc2-mm2
In-Reply-To: <6bffcb0e0708100805i417834e5t87a1ebf122c1e264@mail.gmail.com>
	(Michal Piotrowski's message of "Fri, 10 Aug 2007 17:05:50 +0200")
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC7BDA.3000305@googlemail.com>
	<6bffcb0e0708100805i417834e5t87a1ebf122c1e264@mail.gmail.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Date: Fri, 10 Aug 2007 10:01:14 -0600
Message-ID: <m11webz8dx.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> writes:

> Ah, it is intended.
> sysctl-error-on-bad-sysctl-tables.patch

Yes.  I'm trying to flush out the bad sysctl table entries and prevent
us from adding new ones.

>> [   25.120741] sysctl_check_dir: failed: /kernel  ref: /kernel .1
>> [   25.127102] sysctl table check failed: /kernel  Writable sysctl directory
>> [ 25.134157] sysctl table check failed: /kernel Inconsistent directory names
>> [ 25.141477] sysctl table check failed: /kernel/sched_domain Writable sysctl
> directory
>> [ 25.149755] sysctl table check failed: /kernel/sched_domain/cpu0 Writable
> sysctl directory
>> [ 25.158529] sysctl table check failed: /kernel/sched_domain/cpu0/domain0
> Writable sysctl directory
>> [ 25.168102] sysctl table check failed: /kernel/sched_domain/cpu1 Writable
> sysctl directory
>> [ 25.176862] sysctl table check failed: /kernel/sched_domain/cpu1/domain0
> Writable sysctl directory
>>
>> Eric?

Yes.  For the sched debug case I sent Ingo and friends but apparently
other changes in Ingos tree kept it from applying and Andrew dropped
it.  So instead the code now screams at you and refuses to register
Ingo sysctl table.

Eric
