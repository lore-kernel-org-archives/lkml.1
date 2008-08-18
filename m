Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbYHRGDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbYHRGDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750986AbYHRGCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:02:52 -0400
Received: from kuber.nabble.com ([216.139.236.158]:52667 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYHRGCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:02:51 -0400
Message-ID: <19026358.post@talk.nabble.com>
Date: Sun, 17 Aug 2008 23:02:50 -0700 (PDT)
From: p_ashish <priyadarshi.ashish@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RT-Preemption is causing Very-High Interrupt Latency
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: priyadarshi.ashish@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I applied RT-preemption and High-Resolution Timer Patch to linux-2.6.19.2 . 
It gave satisfactory result for 'cyclic_test' and 
'HR-Timer clock-nanoSleep_test'. 

But the problem is that Interrupt Latency in much more than before. 
This is result which i got from my Interrupt Latency program.

WITH RT-preemption: 
(Max Latency= 513.1 micro seconds and Min Latency= 12.1 micro seconds)

WITHOUT RT-preemption:
(Max Latency= 13.1 micro seconds and Min Latency= 1.8 micro seconds)


Since, RT-preemption implements ISR like threads, so is this the reason for 
higher latency? Is there any way to improve this?

regards
~ashish






-- 
View this message in context: http://www.nabble.com/RT-Preemption-is-causing-Very-High-Interrupt-Latency-tp19026358p19026358.html
Sent from the linux-kernel mailing list archive at Nabble.com.

