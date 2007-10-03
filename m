Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbXJCMQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbXJCMQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXJCMQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:16:08 -0400
Received: from kuber.nabble.com ([216.139.236.158]:38544 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120AbXJCMQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:16:07 -0400
Message-ID: <13017702.post@talk.nabble.com>
Date: Wed, 3 Oct 2007 05:16:05 -0700 (PDT)
From: Giana <Giana_gn@yahoo.com>
To: linux-kernel@vger.kernel.org
Subject: I have a problem with signal mask
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: Giana_gn@yahoo.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I have done Streams multiplexers in Linux kernel. Created two multiplexers
and I could open these 2, close the file descriptors of each and could
link/unlink one with another properly .

But after linking, if i close the descriptor of the linked one: my signals
are unblocked automatically....

Scenario: 
1. Created 2 Multiplexers. Link B under A.
2. Now I set SIG_BLOCK to my current running process.
3. Close file descriptor of B
4. Now the signals are received by the process, It automatically goes for
UN_BLOCK
5. But I want the SIG_BLOCK state should be continued in this case....

Only in this scenario, it happens. All other scenarios like (Unlink without
close fd / close fd with out link) works fine....

Please give me some suggestion on this....

Thanks & Regards,
Giana


-- 
View this message in context: http://www.nabble.com/I-have-a-problem-with-signal-mask-tf4561448.html#a13017702
Sent from the linux-kernel mailing list archive at Nabble.com.

