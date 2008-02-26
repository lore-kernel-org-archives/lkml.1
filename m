Return-Path: <linux-kernel-owner+w=401wt.eu-S1762577AbYBZPQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762577AbYBZPQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 10:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYBZPQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 10:16:16 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:25892 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbYBZPQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 10:16:15 -0500
Message-Id: <47C3E558.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 26 Feb 2008 08:09:28 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <bill.huey@gmail.com>,
       <rostedt@goodmis.org>, <kevin@hilman.org>, <tglx@linutronix.de>,
       <cminyard@mvista.com>, <dsingleton@mvista.com>, <dwalker@mvista.com>,
       "Moiz Kohari" <MKohari@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <acme@redhat.com>, <ak@suse.de>, <gregkh@suse.de>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [(RT RFC) PATCH v2 6/9] add a loop counter based timeout
	mechanism
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
 <20080225160108.11268.1451.stgit@novell1.haskins.net>
 <20080225220601.GH2659@elf.ucw.cz>
In-Reply-To: <20080225220601.GH2659@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Feb 25, 2008 at  5:06 PM, in message
<20080225220601.GH2659@elf.ucw.cz>, Pavel Machek <pavel@ucw.cz> wrote: 
> 
> I believe you have _way_ too many config variables. If this can be set
> at runtime, does it need a config option, too?

Generally speaking, I think until this algorithm has an adaptive-timeout in addition to an adaptive-spin/sleep, these .config based defaults are a good idea.  Sometimes setting these things at runtime are a PITA when you are talking about embedded systems that might not have/want a nice userspace sysctl-config infrastructure.  And changing the defaults in the code is unattractive for some users.  I don't think its a big deal either way, so if people hate the config options, they should go.  But I thought I would throw this use-case out there to ponder.

Regards,
-Greg

