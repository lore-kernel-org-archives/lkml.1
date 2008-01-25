Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbYAYW5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbYAYW5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756683AbYAYW5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:57:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44950 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690AbYAYW5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:57:40 -0500
Date: Fri, 25 Jan 2008 23:57:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 183/196] driver core: fix build with SYSFS=n
Message-ID: <20080125225723.GA26475@elte.hu>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-104-git-send-email-gregkh@suse.de> <20080125222530.GA23769@elte.hu> <20080125223858.GA15723@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125223858.GA15723@suse.de>
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


* Greg KH <gregkh@suse.de> wrote:

> > Changes like this (and it now leaked into Linus' tree as well) kill 
> > bisectability.
> 
> The odds that a "normal" person has sysfs turned off and modules 
> enabled, trying to bisect things, is pretty slim :)

that "slim" combination is what i use for about 25% of all my bisections 
- i build, boot and stress-test randconfig configs.

If i find a problem with a given .config, i do _not_ go around and 
change the .config to make a bisection point work. (and the automated 
bisection scripts definitely wont do it either.)

so what is a 'weird config' to you is a real testing barrier for others. 
And crap like that quickly mounts up. Having a buildable and bootable 
kernel at every bisection point is a _must_.

Please! :-)

	Ingo
