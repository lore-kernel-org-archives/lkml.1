Return-Path: <linux-kernel-owner+w=401wt.eu-S1030412AbXBOSHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030412AbXBOSHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 13:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030418AbXBOSHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 13:07:33 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38638 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030412AbXBOSHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 13:07:33 -0500
Date: Thu, 15 Feb 2007 20:56:55 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/14] syslets: core, documentation
Message-ID: <20070215175654.GA20997@2ka.mipt.ru>
References: <20070215165232.GG4285@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070215165232.GG4285@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Thu, 15 Feb 2007 20:57:03 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:52:32PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> +The syslet atom is a small, fixed-size (44 bytes on 32-bit) piece of
> +user-space memory, which is the basic unit of execution within the syslet
> +framework. A syslet represents a single system-call and its arguments.
> +In addition it also has condition flags attached to it that allows the
> +construction of larger programs (syslets) from these atoms.
> +
> +Arguments to the system call are implemented via pointers to arguments.

I've just thought, how x86/x86_64 problem is going to be solved for
pointer size? Is it better to wire longs/pointers to 64 bits right now?

-- 
	Evgeniy Polyakov
