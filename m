Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbYHaV2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbYHaV2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 17:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758219AbYHaV2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 17:28:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:44856 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbYHaV2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 17:28:31 -0400
Date: Sun, 31 Aug 2008 14:28:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tglx@tglx.de,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [patch v2   0/5] Nano/Microsecond resolution for select() and
 poll()
Message-ID: <20080831142820.40029b56@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0808311411450.6096@alien.or.mcafeemobile.com>
References: <20080831092828.13ae0279@infradead.org>
	<Pine.LNX.4.64.0808311411450.6096@alien.or.mcafeemobile.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008 14:13:45 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Sun, 31 Aug 2008, Arjan van de Ven wrote:
> 
> > Note: 
> > even though poll() (as opposed to ppoll()) only accepts milliseconds
> > as userspace interface, the behavior will still improve because the
> > current time no longer needs to be rounded up to the next jiffie,
> > so on average a 500 microseconds behavior improvement.
> 
> Another way to get down in the timeout resolution for newer kernels,
> and still supporting the syscalls with millisec timeouts, is to use
> timerfds.

perhaps, but once you have to change the app you can also make it use
ppoll() rather than poll().. that's a VERY minute change.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
