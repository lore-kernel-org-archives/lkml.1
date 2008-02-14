Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYBNQQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYBNQQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYBNQQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:16:20 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:46102 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYBNQQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:16:19 -0500
Message-Id: <47B42167.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 14 Feb 2008 09:09:27 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Ingo Molnar" <mingo@elte.hu>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Paul Jackson" <pj@sgi.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/2] reworking load_balance_monitor
References: <20080214155724.772744000@chello.nl>
In-Reply-To: <20080214155724.772744000@chello.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Thu, Feb 14, 2008 at 10:57 AM, in message
<20080214155724.772744000@chello.nl>, Peter Zijlstra <a.p.zijlstra@chello.nl>
wrote: 
> Hi,
> 
> Here the current patches that rework load_balance_monitor.
> 
> The main reason for doing this is to eliminate the wakeups the thing 
> generates,
> esp. on an idle system. The bonus is that it removes a kernel thread.
> 
> Paul, Gregory - the thing that bothers me most atm is the lack of
> rd->load_balance. Should I introduce that (-rt ought to make use of that as
> well) by way of copying from the top sched_domain when it gets created?

With the caveat that I currently have not digested your patch series, this sounds like a reasonable approach.  The root-domain effectively represents the top sched-domain anyway (with the additional attribute that its a shared structure with all constituent cpus).

Ill try to take a look at the series later today and get back to you with feedback.

-Greg

