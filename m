Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbYADWNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbYADWNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbYADWNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:13:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:53331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbYADWNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:13:19 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH x86] [5/16] Replace hard coded reservations in x86-64 early boot code with dynamic table II
Date: Fri, 4 Jan 2008 23:13:14 +0100
User-Agent: KMail/1.9.6
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080103442.621670000@suse.de> <20080104180650.GA2998@bingen.suse.de> <1199472453.4888.19.camel@localhost>
In-Reply-To: <1199472453.4888.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801042313.14551.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 January 2008 19:47:33 Joe Perches wrote:
> On Fri, 2008-01-04 at 19:06 +0100, Andi Kleen wrote:
> > But the problem with your "rule" is that every of the hundreds
> > of Linux kernel contributors will need to do the same. And that's just 
> > ineffecient, waste of valuable human work and just doesn't make much sense.
> > 
> > It certainly won't improve Linux in any way.
> 
> What I would prefer is a git option that supports
> check-in/outs in a coding style of a user choice.

I'm not very deep into git specifics, but for the spaces<->tab problem
I suspect some kind of commit hook script would be the correct solution.
i.e. always convert them in newly changed lines as comitted.

-Andi

