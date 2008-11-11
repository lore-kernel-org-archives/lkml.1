Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYKKVJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYKKVJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 16:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYKKVJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 16:09:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57366 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbYKKVJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 16:09:04 -0500
Date: Tue, 11 Nov 2008 22:08:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>, Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org, srostedt@redhat.com
Subject: Re: [PATCH 1/1] ring-buffer: buffer record on/off switch
Message-ID: <20081111210831.GA16179@elte.hu>
References: <20081111200601.147669239@goodmis.org> <20081111201034.315528609@goodmis.org> <20081111125645.4f7a5827.akpm@linux-foundation.org> <alpine.DEB.1.10.0811111603590.3275@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811111603590.3275@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> On Tue, 11 Nov 2008, Andrew Morton wrote:
> 
> > On Tue, 11 Nov 2008 15:06:02 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > +static struct file_operations rb_simple_fops = {
> > 
> > should be const...
> > 
> > Probably it isn't worth fixing.  Someone(tm) should do period sweeps -
> > 10% of our file_operationses aren't const.
> 
> Thanks, I never really thought about it.
> 
> I'll add to my todo list to send out a patch that cleans all of this 
> up. I think I'm guilty at doing this in more than one place.

Perhaps checkpatch.pl could remind us about it? a new file_operations 
struct definition should be const in 99.9% of the cases.

	Ingo
