Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbYDPKYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbYDPKYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 06:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbYDPKYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 06:24:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:61081 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbYDPKYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 06:24:16 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] Replace completions with semaphores
To: Bart Van Assche <bart.vanassche@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Oeser <ioe-lkml@rameria.de>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Reply-To: 7eggert@gmx.de
Date: Wed, 16 Apr 2008 12:22:46 +0200
References: <ahyFC-2bu-25@gated-at.bofh.it> <ahUPJ-8rN-1@gated-at.bofh.it> <ai4vO-2Rp-19@gated-at.bofh.it> <ai9Yw-5uh-7@gated-at.bofh.it> <aiz6z-OZ-31@gated-at.bofh.it> <aizgp-151-25@gated-at.bofh.it> <aizSW-2Ar-17@gated-at.bofh.it> <aiAYF-5e7-19@gated-at.bofh.it> <aiB8o-5A7-17@gated-at.bofh.it> <aiCnR-7k-39@gated-at.bofh.it> <aiMGu-7f0-7@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Jm4ms-0000uH-Ol@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/+6y2Yhd518ha8fAOwjEcOi/l1aB+E3rww37R
 Np6SzHuy7yk2/CaBsDA1e7cbgwHuNuQY10tjk+EN9D25LXCT7e
 jUpe2m5JJSo7ZbGMnnQTg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche <bart.vanassche@gmail.com> wrote:
> On Mon, Apr 14, 2008 at 9:16 PM, Andi Kleen <andi@firstfloor.org> wrote:

>>  For me it sounds like you just want to rename semaphores to some other
>>  name that people don't use them for normal locking?
> 
> Would it really be a good idea to give a synchronization concept that
> behaves exactly like a semaphore another name than "semaphore" ? The
> semaphore concept is well known and is taught in every computer
> science course.

What about calling it counting_semaphore, if it's to be used for this purpose?

