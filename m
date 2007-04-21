Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXDUVOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXDUVOY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 17:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbXDUVOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 17:14:24 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:55291 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbXDUVOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 17:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=o1TorVhla0dHBa1jjAe2gEVq8HT2aDpcsixS9JtNUq+xWe34aYmlks2xxBO9vVlvLkVt/xK20RU8sH/roLH9IlfVJgCKqET5FZnTy/HbV2aDZ1paINCe1wq6SYRiN2JYVq3Yi+ayr8LJVt17MaRSz8vYN7brp3K/IOotFnmLi2w=
Message-ID: <3efb10970704211414q7c66c154m79cc06db61eb76be@mail.gmail.com>
Date: Sat, 21 Apr 2007 23:14:22 +0200
From: "Remy Bohmer" <l.pinguin@gmail.com>
Reply-To: linux@bohmer.net
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "David Brownell" <david-b@pacbell.net>
Subject: gtod/clocksource/clockevents documentation
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I need to implement a gtod/clocksource/clockevents implementation for
the Atmel ARM AT91SAM9261 CPU, and I am looking for some kernel
(interface) documentation about these mechanisms.

I already investigated the 'examples'/implementations of other
architectures in the kernel, but that did not really help me... I also
looked at the patch for the AT91RM9200 CPU posted by David Brownell...
I hacked something which now makes the RT kernel to boot, but the
time-of-day warps several minutes per second, back and forward in
time... ;-)

So, Can anybody please give me pointer to some useful documentation
and/or examples?

The reason behind this initiative is to make the RT-preempt patch
compile and work on this architecture. Currently the GENERIC_TIME is
not set, which results in several unresolved externals at compile
time, and I believe the best way to fix this is to implement proper
gtod/clocksource/clockevents to allow the enabling of GENERIC_TIME

Kind Regards,

Remy Böhmer
