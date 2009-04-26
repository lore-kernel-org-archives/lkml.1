Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbZDZO7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbZDZO7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 10:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZDZO7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 10:59:25 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:39717 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754793AbZDZO7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 10:59:24 -0400
Message-ID: <440758024.12507@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: ylmao@mail.ustc.edu.cn
From: "Mao Yilu" <ylmao@mail.ustc.edu.cn>
To: <linux-kernel@vger.kernel.org>
Subject: TSC unstable on Intel Pentium M processor 750
Date: Sun, 26 Apr 2009 22:59:13 +0800
Message-ID: <9E8AFFF282BE4091BA53C5D4F911F6F0@xiaomao>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
thread-index: AcnGe4SH2KXZ7QL4QG2xYqctInFiTA==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I masked all the interrupts except keyboard interrupt before the instruction “hlt”, So the CPU ran nothing until I click the keyboard button. And I used “rdtscll” and “do_gettimeofday” to get the halt time. But the result of “do_gettimeofday” was longer than the one of “rdtscll” about 3s per minute. I don’t know why.
I timed some math job using the same way in contrary to the “hlt” instruction. The TSC was not correct either. In 3 minutes, the result of “do_gettimeofday” was longer than the one of “rdtscll” about 5s.
The processor is Intel Pentium M processor 750. From the software developer’s manual of Intel, the processor clock of Pentium M processors is impacted by Intel SpeedStep technology, while some other processors is not. Maybe this is another feature Pentium M processors own.
Pentium M processors support 5 C-states. I am sure the TSC doesn’t stop in C0 and C1 states. But I am not sure about other states. Maybe other states will stop the clock, and “hlt” instruction will make the CPU into deeper state.
These are my guess. I wanna the truth. Thank you.

Mao Yilu

