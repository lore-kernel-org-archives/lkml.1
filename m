Return-Path: <linux-kernel-owner+w=401wt.eu-S1763557AbYCDKa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763557AbYCDKa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbYCDKaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:30:13 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:57440 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbYCDKaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:30:12 -0500
From: Paul Collins <paul@burly.ondioline.org>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] 11s softlockup and hang with kvm on 2.6.24.3
References: <873ar6rhq3.fsf@burly.wgtn.ondioline.org>
	<47CD1634.6030901@qumranet.com>
Date: Tue, 04 Mar 2008 23:27:18 +1300
In-Reply-To: <47CD1634.6030901@qumranet.com> (Avi Kivity's message of "Tue, 04
	Mar 2008 11:28:20 +0200")
Message-ID: <87y78ypywp.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@qumranet.com> writes:

> Paul Collins wrote:
>> Running kvm 62 on 2.6.24.3 (the extraversion is reported due to a local
>> patch to vfat) I just got a couple of soft lockups and a hang.  I was
>> installing FreeBSD 7 at the time.
>>
>> Mar  4 21:20:13 burly kernel: Call Trace:
>> Mar  4 21:20:13 burly kernel:  [<ffffffff8024b60e>] hrtimer_try_to_cancel+0x67/0x70
>> Mar  4 21:20:13 burly kernel:  [<ffffffff8024b629>] hrtimer_cancel+0x12/0x16
>> Mar  4 21:20:13 burly kernel:  [<ffffffff8024b623>] hrtimer_cancel+0xc/0x16
>> Mar  4 21:20:13 burly kernel:  [<ffffffff880fc9cd>] :kvm:kvm_migrate_apic_timer+0x19/0x2e
>
> Can you reproduce and send the output of sysrq-t?  Looks like the
> timer callback is stuck.

I'll give it a lash.

I was able to complete the installation with kvm 62 on 2.6.25-rc3-369-g976dde0.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
