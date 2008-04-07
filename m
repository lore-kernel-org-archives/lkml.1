Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbYDGRSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbYDGRSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 13:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYDGRSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 13:18:14 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:60614 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbYDGRSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 13:18:14 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [BUG] CONFIG_IRQBALANCE=y broken?
Date: Mon, 7 Apr 2008 20:17:59 +0300
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200804072017.59428.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Thomas,

When kernel-2.6.24.x is compiled with 

CONFIG_IRQBALANCE=y, 

and heavy LAN (outbound) traffic, I experience LAN dying due to
IRQ# masked at the IO_APIC (bit 16 is 1, for the corresponding irq
vector) (SMP x86_32,  AMD X2), as described in my previous post:

http://lkml.org/lkml/2008/3/25/165

and links to previous posts there in. When

CONFIG_IRQBALANCE is not set

I am not able to reproduce the problem. That makes me think that 
there is a race/bug somewhere in the irq balancing code that 
leaves (rarely) the corresponding IRQ# masked at the IO-APIC.

Any comments, suggestions, patches?

Additional info?

Thank you in advance for your answer.

Regards

Marin Mitov

