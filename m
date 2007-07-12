Return-Path: <linux-kernel-owner+w=401wt.eu-S934368AbXGLUok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368AbXGLUok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbXGLUob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:44:31 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52480 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbXGLUoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:44:30 -0400
X-Greylist: delayed 1247 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 16:44:30 EDT
Subject: Re: Forward port of latest RT patch (2.6.21.5-rt20) to 2.6.22
	available
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gregory Haskins <ghaskins@novell.com>, jim.houston@ccur.com,
       joe.korty@ccur.com, rostedt@goodmis.org, tglx@linutronix.de,
       dwalker@mvista.com, David Bahi <DBahi@novell.com>,
       Moiz Kohari <MKohari@novell.com>, dsaxena@plexity.net,
       williams@redhat.com, abogani@texware.it, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <20070712163341.GA9622@elte.hu>
References: <46961E080200005A000276AE@mcclure.wal.novell.com>
	 <20070712163341.GA9622@elte.hu>
Content-Type: text/plain
Organization: Suse
Date: Thu, 12 Jul 2007 13:21:40 -0700
Message-Id: <1184271700.24942.175.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-3.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 18:33 +0200, Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
> 

> 
> ok. Make sure you check rt2 as well - and note that it's not fully 
> bisectable with PREEMPT_RT enabled (but should probably be fully 
> bisectable with PREEMPT_RT disabled). So check out first whether the 
> problem still persists with PREEMPT_RT disabled.
> 

There is also a regression on my Dell 690 dual-quadcore

rt2 hangs like a brick at boot. rt1 comes up fine.

I am configured at max 8 CPUs so it doesn't seem to be an out of memory
situation.

I'll look at the interdiffs and see what I can find.

Regards,

Sven

> 	Ingo
-- 
Sven-Thorsten Dietrich
+1 415 694-2930
( www.novell.com/linux )

