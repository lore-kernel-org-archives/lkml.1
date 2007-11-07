Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbXKGDfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbXKGDfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 22:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbXKGDfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 22:35:36 -0500
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:36219 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752398AbXKGDff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 22:35:35 -0500
X-YMail-OSG: ef0JqssVM1lpd_OS9ZIr4VnWq6N7RfAUBiVRvY8bGMKXGKaUjTPK_brQ4u_YfhnRYkwbzSaQGg--
X-RocketYMMF: rancidfat
Date: Tue, 6 Nov 2007 19:35:34 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Defense in depth: LSM *modules*, not a static interface
To: Cliffe <cliffe@ii.net>, Peter Dolding <oiaohm@gmail.com>
Cc: Crispin Cowan <crispin@crispincowan.com>, Simon Arlott <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <4731361D.9030504@ii.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <671729.27434.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Cliffe <cliffe@ii.net> wrote:

> As good an idea POSIX capabilities might be,

Now that's a refreshing comment. Thank you.

> not all security problems 
> can be solved with a bitmap of on/off permissions.

There are people (I'm not one of them) who figure that you
can solve all the security problems by applying sufficiently
fine granularity of on/off permissions.

> Peter Dolding wrote:
> <lots o stuff>
> 
> Ok but what happens to the principle of least privilege?
> 
> What if we want AppArmor to confine that application to use a particular 
> set of ports?
> 
> Do you propose having a capability for each port? how about protocols?

While you're at it, how about a capability for each possible
directory entry name?

> So unless my understanding of capabilities is fundamentally flawed 
> (which it may be - I have not spent time reviewing recent changes) 
> obviously Linux capabilities does not provide a solution to every problem.

Of course they don't. The only problem they are intended
to solve, and I really mean this, is the association of uid 0
with privilege. That's it. You would be better off with a single
CAP_GODLIKE than with uid 0 having all privilege all the time.
Fine grained capabilities are a bonus, and there are lots of
people who think that it would be really nifty if there were a
separate capability for each "if" in the kernel. I personally
don't see need for more than about 20. That is a matter of taste.
DG/UX ended up with 330 and I say that's too many.



Casey Schaufler
casey@schaufler-ca.com
