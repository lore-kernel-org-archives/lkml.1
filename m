Return-Path: <linux-kernel-owner+w=401wt.eu-S1763565AbXJOLUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763565AbXJOLUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757094AbXJOLUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:20:07 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:46115 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbXJOLUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:20:05 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest =?iso-8859-15?q?time=09accounting=2E?=
Date: Mon, 15 Oct 2007 13:19:28 +0200
User-Agent: KMail/1.9.7
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <46E550EF.5080209@bull.net> <47133ABD.8050608@qumranet.com> <471346B0.8050102@bull.net>
In-Reply-To: <471346B0.8050102@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710151319.28410.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

forgot to CC everybody besides Laurent:

Am Montag, 15. Oktober 2007 schrieben Sie:
> No, It must not be cleared here because we can't enter in the accounting code
> between kvm_guest_enter(void) and kvm_guest_exit(void).
> 
> This is why the accounting code clears it.
> 
> I put a kvm_guest_exit() only for symmetry.

Why cant we enter the accounting code?
Dont know about x86, but on s390 we can get host interrupts and reschedules
even when we run a guest (if preemption is on).

If the timer tick happens  while the guest is running, we will run the
accounting code on x86 as well, no? 


Christian



-- 
IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Geschäftsführung: Herbert Kircher 
Sitz der Gesellschaft: Böblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

