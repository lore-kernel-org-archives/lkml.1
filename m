Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbXFPPy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbXFPPy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 11:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXFPPyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 11:54:51 -0400
Received: from homer.mvista.com ([63.81.120.158]:11862 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbXFPPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 11:54:51 -0400
Subject: Re: [patch-mm 15/25] clocksource: add settimeofday hook for PPC
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Tony Breeds <tony@bakeyournoodle.com>,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <20070616101637.107940593@inhelltoy.tec.linutronix.de>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
	 <20070616101637.107940593@inhelltoy.tec.linutronix.de>
Content-Type: text/plain
Date: Sat, 16 Jun 2007 08:51:23 -0700
Message-Id: <1182009083.11539.369.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-16 at 10:36 +0000, Thomas Gleixner wrote:
> plain text document attachment
> (clocksource-add-settimeofday-hook.patch)
> From: Tony Breeds <tony@bakeyournoodle.com >
> 
> I'm working on a clocksource implementation for all powerpc platforms.
> some of these platforms needs to do a little work as part of the
> settimeofday() syscall and I can't see a way to do that without adding
> this hook to clocksource.
> 


I'd like to see how this is used? If the code that uses this API change
isn't ready yet, then this patch should really wait..

Daniel

