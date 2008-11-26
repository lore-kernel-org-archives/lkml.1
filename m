Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbYKZGz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbYKZGz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 01:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbYKZGzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 01:55:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42962 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYKZGzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 01:55:16 -0500
Date: Wed, 26 Nov 2008 07:54:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] ftrace: add function tracing to single thread
Message-ID: <20081126065425.GA26036@elte.hu>
References: <20081126051622.134970943@goodmis.org> <20081126051709.571204072@goodmis.org> <m1hc5vasye.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hc5vasye.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > +/* ftrace_pid_trace >= 0 will only trace threads with this pid */
> > +static int ftrace_pid_trace = -1;
> 
> Why not?
> static struct pid *ftrace_pid_trace = NULL;

ok, looks reasonably simple at first sight.

Steve, mind sending the conversion of this facility to struct pid as a 
delta patch? (that would have education purposes as well, for similar 
situations)

	Ingo
