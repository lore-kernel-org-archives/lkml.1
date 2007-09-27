Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbXI0Qpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbXI0Qpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 12:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbXI0Qpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 12:45:38 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51606 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbXI0Qph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 12:45:37 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Sep 2007 09:45:34 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk-manpages@gmx.net>
cc: rdunlap@xenotime.net, Andrew Morton <akpm@linux-foundation.org>,
       hch@lst.de, geoff@gclare.org.uk, tglx@linutronix.de, david@hardeman.nu,
       Ulrich Drepper <drepper@redhat.com>, subrata@linux.vnet.ibm.com,
       corbet@lwn.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Man page for revised timerfd API
In-Reply-To: <20070927103531.184550@gmx.net>
Message-ID: <Pine.LNX.4.64.0709270944300.763@alien.or.mcafeemobile.com>
References: <46FA0657.20700@gmx.net> <Pine.LNX.4.64.0709261038550.25778@alien.or.mcafeemobile.com>
 <20070927103531.184550@gmx.net>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007, Michael Kerrisk wrote:

> Davide,
> 
> A further question: what is the expected behavior in the
> following scenario:
> 
> 1. Create a timerfd and arm it.
> 2. Wait until M timer expirations have occurred
> 3. Modify the settings of the timer
> 4. Wait for N further timer expirations have occurred
> 5. read() from the timerfd
> 
> Does the buffer returned by the read() contain the value
> N or (M+N)?  In other words, should modifying the timer
> settings reset the expiration count to zero?

Every timerfd_settime() zeroes the tick counter. So in your scenario it'll 
return N.



- Davide


