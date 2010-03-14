Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab0CNTJF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 15:09:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33874 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759577Ab0CNTJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 15:09:01 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Larry Finger <Larry.Finger@lwfinger.net>,
       WANG Cong <xiyou.wangcong@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] base firmware: Fix BUG from sysfs attributes change in commit a2db6842873c8e5a70652f278d469128cb52db70
References: <4b9be956.x5+yAHXGDfXer810%Larry.Finger@lwfinger.net>
	<alpine.LFD.2.00.1003131426480.3719@i5.linux-foundation.org>
	<alpine.LRH.2.00.1003132336380.12517@twin.jikos.cz>
	<alpine.LFD.2.00.1003131455420.3719@i5.linux-foundation.org>
	<m1fx43zhbd.fsf@fess.ebiederm.org>
	<loom.20100314T113306-436@post.gmane.org>
	<alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 14 Mar 2010 12:08:55 -0700
In-Reply-To: <alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org> (Linus Torvalds's message of "Sun\, 14 Mar 2010 11\:04\:25 -0700 \(PDT\)")
Message-ID: <m1fx42yb3s.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: torvalds@linux-foundation.org, tj@kernel.org, gregkh@suse.de, xiyou.wangcong@gmail.com, Larry.Finger@lwfinger.net, jkosina@suse.cz, linux-kernel@vger.kernel.org, w.sang@pengutronix.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, 14 Mar 2010, Wolfram Sang wrote:
>>
>> coccinelle can apply semantic patches, rough description here [1]. So I wrote
>> one which checks for every c-file in the kernel-tree:
>>
>> - Is there a structure containing (bin_)attribute?
>> - Does a function declare a pointer to such a structure?
>> - Is this pointer then used for a sysfs_create(_bin)_file?
>> - If so, has there been a call to sysfs(_bin)_attr_init before?
>>
>> If not -> report. As coccinelle works on an abstract level of the code (not on
>> source-code level), it can follow code-paths and such. Really nice tool, once
>> you gathered the information to learn it.

Any chance you can post the semantic patch?  If it isn't too hard it
would be nice to have the warm fuzzy of running it myself and seeing
that there are no more of these left in the kernel.

Eric
