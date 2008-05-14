Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbYENHTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbYENHTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYENHTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:19:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYENHTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:19:04 -0400
Date: Wed, 14 May 2008 09:18:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, acme@redhat.com, srostedt@redhat.com,
       linux-kernel@vger.kernel.org, pq@iki.fi, proski@gnu.org,
       sandmann@redhat.com, rostedt@goodmis.org, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 0/2]: Add sparc64 ftrace support.
Message-ID: <20080514071843.GA21324@elte.hu>
References: <20080514063055.GA21369@elte.hu> <20080514065156.GA3159@uranus.ravnborg.org> <20080514070148.GA10549@elte.hu> <20080514.001150.119391237.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514.001150.119391237.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* David Miller <davem@davemloft.net> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 14 May 2008 09:01:48 +0200
> 
> > (i also sort by length to make it visually more appealing. "Reverse 
> > christmas tree" sorting ;-)
> 
> I do this for local variable declarations too.

yeah, same here:

  --------------------------------->
  static void
  ftrace_record_ip(unsigned long ip)
  {
          struct dyn_ftrace *node;
          unsigned long flags;
          unsigned long key;
          int resched;
          int atomic;
          int cpu;
  [...]
  <--------------------------------

for me the primary motivation isnt even merge conflicts in this case 
(getting conflicts on this level is rare), but readability and making it 
smooth to move the eye off the variable declarations.

IMO good code is obvious even without having to read the types, so the 
less visually intrusive the variable declarations section is, the 
better.

	Ingo
