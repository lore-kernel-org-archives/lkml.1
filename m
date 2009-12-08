Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbZLHL0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbZLHL0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZLHL0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:26:30 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54865 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbZLHL03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:26:29 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnd Bergmann <arnd@arndb.de>
References: <alpine.LFD.2.00.0912061857340.3089@localhost.localdomain>
	<m1iqci4ful.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912081211350.3089@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 08 Dec 2009 03:26:27 -0800
In-Reply-To: <alpine.LFD.2.00.0912081211350.3089@localhost.localdomain> (Thomas Gleixner's message of "Tue\, 8 Dec 2009 12\:14\:09 +0100 \(CET\)")
Message-ID: <m17hsx1zbw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [GIT pull] bkl core patches for 2.6.33
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Mon, 7 Dec 2009, Eric W. Biederman wrote:
>> Thomas Gleixner <tglx@linutronix.de> writes:
>> 
>> > Linus,
>> >
>> > Please pull the latest bkl-core-for-linus git tree from:
>> >
>> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git bkl-core-for-linus
>> >
>> > Thanks,
>> 
>> 
>> Was this tree in linux-next?  I'm certain I would have remembered the
>> conflict in kernel/sysctl.c.  Among other things in my sysctl tree
>> lock_kernel() is gone.  The removal of lock_kernel() happened to fall
>> out of my other changes.  I remember having a conversation with Arnd
>> Bergmann about this, and the conclusion being was that my change
>> correct and superior to this patch.  So I'm surprised a sysctl change
>> made it into your tree.
>
> Sorry, that change was excluded from next and I completely forgot
> about your patches when I was preparing the pull request. Zapped the
> commit in question already.

Thanks.  That is one less minor conflict to worry about.

Eric
