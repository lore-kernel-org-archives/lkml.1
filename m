Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXBNMkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXBNMkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 07:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932229AbXBNMkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 07:40:04 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34547 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932232AbXBNMkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 07:40:02 -0500
Date: Wed, 14 Feb 2007 13:37:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070214123755.GC23857@elf.ucw.cz>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213142010.GA638@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
  
> The boring details:
> 
> Syslets consist of 'syslet atoms', where each atom represents a single 
> system-call. These atoms can be chained to each other: serially, in 
> branches or in loops. The return value of an executed atom is checked 
> against the condition flags. So an atom can specify 'exit on nonzero' or 
> 'loop until non-negative' kind of constructs.

Ouch, yet another interpretter in kernel :-(. Can we reuse acpi or
something?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
