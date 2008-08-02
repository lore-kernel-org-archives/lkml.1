Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbYHBExS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbYHBExS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 00:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYHBExF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 00:53:05 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53068 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYHBExE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 00:53:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
	<m1iqukwjjg.fsf@frodo.ebiederm.org>
	<86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>
	<m1wsj0nyx6.fsf@frodo.ebiederm.org>
	<86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>
	<m163qkjirc.fsf@frodo.ebiederm.org>
	<86802c440808011901w2aa40b25u45f5686b262cc2aa@mail.gmail.com>
	<4893C066.60401@zytor.com> <m1abfwi1ht.fsf@frodo.ebiederm.org>
	<4893D459.4030209@zytor.com>
Date: Fri, 01 Aug 2008 21:42:54 -0700
In-Reply-To: <4893D459.4030209@zytor.com> (H. Peter Anvin's message of "Fri,
	01 Aug 2008 20:28:25 -0700")
Message-ID: <m14p64gh81.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"H. Peter Anvin" <hpa@zytor.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0211]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>>
>> Having a human readable name like: eth0irq22 or hbairq5 is likely just
>> as good in the case of msi.  Still all of the users interfaces today take
> numbers.
>> So we are stuck with dealing with numbers for a long time to come.
>>
>
> Long sparse numbers are messy, too, though.  It might be interesting to have a
> routine somewhere like "irq_name()" to output a human-readable IRQ name, which
> in case of MSI-X could contain the PCI device name.

Yes.  I want the option of using those bits.  It might not be smart to
use them to encode a physical location and the irq number but just
having the option would be nice.

Making /proc/interrupts useful without breaking user space is going to be
an interesting challenge one of these days.

Eric
