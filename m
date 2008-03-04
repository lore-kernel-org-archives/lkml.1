Return-Path: <linux-kernel-owner+w=401wt.eu-S1762363AbYCDJ2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762363AbYCDJ2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 04:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYCDJ2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 04:28:25 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:40856
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbYCDJ2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 04:28:23 -0500
Message-ID: <47CD1634.6030901@qumranet.com>
Date: Tue, 04 Mar 2008 11:28:20 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] 11s softlockup and hang with kvm on 2.6.24.3
References: <873ar6rhq3.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <873ar6rhq3.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins wrote:
> Running kvm 62 on 2.6.24.3 (the extraversion is reported due to a local
> patch to vfat) I just got a couple of soft lockups and a hang.  I was
> installing FreeBSD 7 at the time.
>
>
> Mar  4 21:20:13 burly kernel: Call Trace:
> Mar  4 21:20:13 burly kernel:  [<ffffffff8024b60e>] hrtimer_try_to_cancel+0x67/0x70
> Mar  4 21:20:13 burly kernel:  [<ffffffff8024b629>] hrtimer_cancel+0x12/0x16
> Mar  4 21:20:13 burly kernel:  [<ffffffff8024b623>] hrtimer_cancel+0xc/0x16
> Mar  4 21:20:13 burly kernel:  [<ffffffff880fc9cd>] :kvm:kvm_migrate_apic_timer+0x19/0x2e
>   

Can you reproduce and send the output of sysrq-t?  Looks like the timer 
callback is stuck.

-- 
error compiling committee.c: too many arguments to function

