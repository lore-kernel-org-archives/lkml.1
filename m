Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZLTLkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZLTLkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 06:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZLTLkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 06:40:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48678 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZLTLkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 06:40:01 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B2E0CFB.30806@s5r6.in-berlin.de>
Date: Sun, 20 Dec 2009 12:39:39 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091025 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
Subject: On "ratelimit: Use per ratelimit context locking"
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

in pre 2.6.33-rc1 commit 979f693d you wrote: "I'd like to use
printk_ratelimit() in atomic context, but that's not possible right now
due to the spinlock usage this commit introduced more than a year ago:
717115e: printk ratelimiting rewrite".¹,²

By not possible, do you mean it would be an outright bug to call
printk_ratelimit in atomic context prior to 979f693d, or merely a
performance issue?  If the former, under which circumstances would the
bug hit?

I'm asking because one of my commits actually introduced a
printk_ratelimit use in an interrupt handler shortly before 2.6.32 was
released.  In my testing, it didn't occur to me that there might be a
problem.

¹http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=979f693def9084a452846365dfde5dcb28366333
²http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=717115e1a5856b57af0f71e1df7149108294fc10
-- 
Stefan Richter
-=====-==--= ==-- =-=--
http://arcgraph.de/sr/
