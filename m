Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYABUYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYABUYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYABUYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:24:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57111 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbYABUYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:24:09 -0500
Date: Wed, 2 Jan 2008 21:23:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, qbarnes@gmail.com,
       ananth@in.ibm.com, jkenisto@us.ibm.com
Subject: Re: [PATCH] x86: kprobes change kprobe_handler flow
Message-ID: <20080102202315.GE3985@elte.hu>
References: <1198806265.6323.34.camel@brick> <4778E8B0.6010400@gmail.com> <20080101153558.GJ4434@elte.hu> <477A971A.8030006@gmail.com> <477BD366.1060504@redhat.com> <863e9df20801021131j3a4d655dgd00fa60e39a97ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <863e9df20801021131j3a4d655dgd00fa60e39a97ec@mail.gmail.com>
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


* Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> > > +     default:
> > > +             /* impossible cases */
> > > +             BUG();
> >
> > I think no need to check that here.
> 
> It may not get hit at runtime but is quite informative.

sidenote: please use WARN_ON(1) instead. In the case of the impossible 
triggering somehow (the Linux kernel is notorious for that ;-), we'd 
have a nice WARN_ON(1) in the dmesg, instead of a crashed box.

	Ingo
