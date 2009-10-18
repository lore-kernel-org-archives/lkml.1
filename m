Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZJRQRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZJRQRL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 12:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZJRQRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 12:17:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbZJRQRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 12:17:10 -0400
Date: Sun, 18 Oct 2009 18:16:40 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
cc: Arnd Bergmann <arndbergmann@googlemail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCHES 0/5] Remove smp_lock.h in the BKL removal effort
Message-ID: <alpine.LFD.2.00.0910181812310.3462@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches remove the smp_lock.h include in files that 
no-longer use the BKL.

A few of them rely on patches already sent by various people in the remove 
the bkl effort - and they may only exist in Thomas' queue.

I could have made this one big patch, but I thought that breaking them up
by architecture would make bisecting more logical.

Thanks

John Kacur
