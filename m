Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbXL3N5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbXL3N5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbXL3N5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:57:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53721 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbXL3N47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:56:59 -0500
Date: Sun, 30 Dec 2007 14:47:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
Message-ID: <20071230134747.GI16946@elte.hu>
References: <1198807702.6323.37.camel@brick> <477751D1.8080909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477751D1.8080909@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> And also, I prefer "return 1" to "{ret = 1; goto out;}" for 
> simplicity.

it seems that the code already uses 'ret', and sets it to 1 in certain 
cases - in that light it's a tiny bit cleaner to just have a single 
return code flow.

	Ingo
