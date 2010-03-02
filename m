Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab0CBV02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:26:28 -0500
Received: from smtp4.Stanford.EDU ([171.67.219.84]:40655 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750905Ab0CBV01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:26:27 -0500
Subject: Re: [ANNOUNCE] 2.6.33-rt3
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: nando@ccrma.Stanford.EDU, Xavier Miller <xavier.miller@cauwe.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, Carsten Emde <ce@ceag.ch>
In-Reply-To: <alpine.LFD.2.00.1002271252300.4245@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>
	 <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>
	 <4B88E4F3.4010308@cauwe.org>
	 <alpine.LFD.2.00.1002271252300.4245@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 02 Mar 2010 13:25:38 -0800
Message-Id: <1267565138.6898.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-27 at 12:53 +0100, Thomas Gleixner wrote:
> On Sat, 27 Feb 2010, Xavier Miller wrote:
> 
> > Hello,
> > 
> > The name is -rt4, not -rt3
> 
> I pushed out an -rt4 w/o notice in the morning because I forgot to
> pick up a few trivial fixes for -rt3.

Hmm, I had to comment out a VM_BUG_ON for pkmap_count in mm/highmem.c,
looks like pkmap_count is not defined anywhere else?

-- Fernando


