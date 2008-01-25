Return-Path: <linux-kernel-owner+w=401wt.eu-S1762265AbYAYXUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762265AbYAYXUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:20:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761995AbYAYXTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:19:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbYAYXTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:19:10 -0500
Date: Sat, 26 Jan 2008 00:18:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 183/196] driver core: fix build with SYSFS=n
Message-ID: <20080125231849.GA12518@elte.hu>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-104-git-send-email-gregkh@suse.de> <20080125222530.GA23769@elte.hu> <20080125223858.GA15723@suse.de> <20080125225723.GA26475@elte.hu> <20080125231040.GC25074@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125231040.GC25074@suse.de>
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

> > Please! :-)
> 
> Yes, I do agree that this is important, I'll work to not let this 
> happen again.  Especially now that I have your build scripts, I'm 
> working on setting up something like that myself here.

btw., Harvey Harrison has cleaned them up some more, and has told me 
about KCONFIG_ALLCONFIG, which is very useful when you want to tailor 
randconfig builds to different testsystems (which might have different 
minimum driver requirements and different distro requirements for kernel 
features). Harvey, could you send the latest version of those 
auto-Kconfig cleanups?

	Ingo
