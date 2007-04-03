Return-Path: <linux-kernel-owner+w=401wt.eu-S965655AbXDCKrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655AbXDCKrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 06:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966150AbXDCKrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 06:47:00 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:33120 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965655AbXDCKq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 06:46:59 -0400
Message-ID: <46122F98.8030302@hitachi.com>
Date: Tue, 03 Apr 2007 19:42:32 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: Re: [PATCH 0/3] VM throttling: avoid blocking occasional writers
References: <45F7EDC6.5090303@hitachi.com> <20070315110745.af867b10.akpm@linux-foundation.org> <45FD53DB.5000207@tmr.com> <460218D2.40701@hitachi.com> <46026B78.3080401@tmr.com> <4607A01D.1060401@hitachi.com> <4607FECD.1090101@tmr.com>
In-Reply-To: <4607FECD.1090101@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Thanks for your comments.
I'm sorry for my late reply.

Bill Davidsen wrote:
>> Then, what do you think of the following idea?
>>
>> (4) add `dirty_start_writeback_ratio' as percentage of memory,
>>     at which a generator of dirty pages itself starts writeback
>>     (that is, non-blocking ratio).
>>
>> In this way, `dirty_ratio' is used as the blocking ratio, so we don't
>> need to modify the sysctl.conf etc. I think it's easier to understand
>> for administrators of systems, because the interface is similar as
>> `dirty_background_ratio' and`dirty_ratio.'
>>
> It sounds good to me, just be sure behavior is sane for for both
> blocking less than start_writeback and vice versa.

Then I'm going to post the new patchset.
In my new patchset, if dirty_ratio < dirty_start_writeback_ratio,
dirty_start_writeback_ratio is just regarded as the same value as
dirty_ratio, and then the kernel behaves similarly as the current kernel.

Regards,
-- 
Tomoki Sekiyama
Hitachi, Ltd., Systems Development Laboratory

