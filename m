Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbYHZEP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbYHZEP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 00:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbYHZEPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 00:15:15 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:52284 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbYHZEPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 00:15:14 -0400
Subject: Re: 2.6.26.3-rt3 bug report
From: Jon Masters <jonathan@jonmasters.org>
To: John Kacur <jkacur@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <520f0cf10808251615r5953794x9816bd58ea771ab3@mail.gmail.com>
References: <520f0cf10808241551x2fe64e9esadf66634b3790c54@mail.gmail.com>
	 <520f0cf10808251615r5953794x9816bd58ea771ab3@mail.gmail.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 26 Aug 2008 00:14:40 -0400
Message-Id: <1219724080.25366.13.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 01:15 +0200, John Kacur wrote:

> Slightly different form today.
> 
> Bad page state in process 'firefox-bin'
> page:ffffe20000daa360 flags:0x0100000000000000
> mapping:ffffe20000daa378 mapcount:0 count:0
> Trying to fix it up, but a reboot is needed
> Backtrace:
> Pid: 16955, comm: firefox-bin Not tainted 2.6.26.3-rt3 #3

Er, does firefox run reliably on a non-RT 2.6.26.3 kernel? This many
random calls to bad_page suggests more of a RAM problem.

Jon.


