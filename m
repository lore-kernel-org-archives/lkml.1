Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbYHaVN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbYHaVN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 17:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYHaVNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 17:13:48 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59768 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbYHaVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 17:13:47 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 31 Aug 2008 14:13:45 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Arjan van de Ven <arjan@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tglx@tglx.de,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch v2   0/5] Nano/Microsecond resolution for select() and
 poll()
In-Reply-To: <20080831092828.13ae0279@infradead.org>
Message-ID: <Pine.LNX.4.64.0808311411450.6096@alien.or.mcafeemobile.com>
References: <20080831092828.13ae0279@infradead.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008, Arjan van de Ven wrote:

> Note: 
> even though poll() (as opposed to ppoll()) only accepts milliseconds
> as userspace interface, the behavior will still improve because the current
> time no longer needs to be rounded up to the next jiffie, so on average
> a 500 microseconds behavior improvement.

Another way to get down in the timeout resolution for newer kernels, and 
still supporting the syscalls with millisec timeouts, is to use timerfds.


- Davide


