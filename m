Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXIEWwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXIEWwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 18:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbXIEWwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 18:52:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:51641 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbXIEWwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 18:52:11 -0400
Message-ID: <46DF3306.7030608@onlinehome.de>
Date: Thu, 06 Sep 2007 00:51:50 +0200
From: Felix Homann <fexpop@onlinehome.de>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andi Kleen <ak@suse.de>
Subject: Re: Regressions w.r.t. suspend behaviour in recent kernel versions
References: <46CED24F.1020400@onlinehome.de> <20070905093605.ac755ce6.akpm@linux-foundation.org>
In-Reply-To: <20070905093605.ac755ce6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18Sv+uJhLe3inUnBKPzZeFmplPMw3VOQxU9o1k
 Z4NvQkn30Tvv/N8oJxKLfHnAjcQHAwbPLkpNDE3uMHSwPZ5nM+
 9Pz0WelKJ37tZAaZIFoBifR0V8eDDlX
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Fri, 24 Aug 2007 14:42:55 +0200 Felix Homann <fexpop@onlinehome.de> wrote:
> 
> Nearly two weeks, zero replies.

Thanks for caring :-)

> 
>> Aug  9 00:22:13 jawaka kernel: EXT3-fs: mounted filesystem with ordered
>> data mode.
>> Aug  9 00:22:13 jawaka kernel: WARNING: at kernel/irq/resend.c:70
>> check_irq_resend()
> 
> I expect that got fixed in later kernels.

Yes, I've just tried 2.6.23-rc5-git1 and the warning has gone!


>> Without the nolapic option the kernel will panic when trying to suspend 
>> to disk.
> 
> A *large* number of people need noapic or nolapic to get Linux to work.

Even better, on 2.6.23-rc5-git1 I don't need nolapic anymore!


>> Here are the last lines of the kernel output:
>>
>> EIP: [<c01127fd> lapic_nmi_suspend+0x1d/0x30 ss:ESP 0068:c1ae3ec8
>> Kernel panic - not syncing: Attempted to kill init!
> 
> Are you able to provide us with more information about this bug? 

If you're still interested in more more information now that the bug has 
apparently been solved "en passant" I can take a photograph tomorrow. 
Please, let me know.

>> With more recent kernels the system will hang with 
>> "Suspending console(s)".
> 
> My Vaio reliably hangs at the same place with 2.6.23-rc4.  I'll bisect that
> next week sometime.  Hopefully the result of that effort will fix your bug.
>  Please test Linus's tree regularly and don't let us release 2.6.23 until
> it is fixed.

Great!


>> 3. Even with the 2.6.18 kernel sound won't work after suspending to ram. 
>> I don't know when this started, but I know that this has not been an 
>> issue in the past.
> 
> Please provide full details in a separate bug report.  Send that report to
> myself, linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz> and
> Takashi Iwai <tiwai@suse.de>

I'll do that in the next couple of days.

Thanks again,

Felix

