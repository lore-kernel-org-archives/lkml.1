Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbXLROB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbXLROB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 09:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756135AbXLROBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 09:01:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073AbXLROBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 09:01:49 -0500
Date: Tue, 18 Dec 2007 15:00:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 7/21] [PATCH] unify common parts of processor.h
Message-ID: <20071218140034.GD17470@elte.hu>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <20071218114504.GA22832@elte.hu> <4767B78A.5030903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4767B78A.5030903@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

>> due to zapping this bit of include/asm-x86/processor_32.h:
>>
>>  -/* Forward declaration, a strange C thing */
>>  -struct task_struct;
>>  -struct mm_struct;
>>
>> 	Ingo
>>
> I'll test it with your config, and repost.

i've pushed out a new iteration of x86.git, which includes 20 out of 
your 21 patches, so please repost relative to that tree.

i have fixed the above problem by adding those 3 lines.

	Ingo
