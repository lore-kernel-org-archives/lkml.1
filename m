Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494Ab0AZMvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0AZMvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888Ab0AZMvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:51:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab0AZMvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:51:37 -0500
Date: Tue, 26 Jan 2010 13:51:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Oliver Neukum <oliver@neukum.org>, smurf@smurf.noris.de,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: option driver freezing entire system
In-Reply-To: <1264187509.12168.30.camel@localhost>
Message-ID: <alpine.LRH.2.00.1001261350530.15694@twin.jikos.cz>
References: <1263577116.27788.131.camel@localhost>  <201001151855.46217.oliver@neukum.org>  <1263580615.27788.134.camel@localhost>  <alpine.LRH.2.00.1001181656500.15694@twin.jikos.cz> <1264187509.12168.30.camel@localhost>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jan 2010, Kasper Sandberg wrote:

> > > > Please recompile your kernel with lockdep. This should improve
> > > > debugging.
> > > 
> > > It is a debian unstable .32 kernel i run now, and grepping for lockdep
> > > reveals:
> > > CONFIG_LOCKDEP_SUPPORT=y
> > > only, is there anything more i should have? (never used lockdep before)
> > 
> > CONFIG_PROVE_LOCKING could be helpful here. (be aware of the fact that 
> > this will make your system noticeably slower).
> 
> Sorry, i was just away a few days. I shall enable this setting tomorow
> and test, though it may take a few days for it to crash.

This option should ideally report the lock ordering violation before the 
actual hang happens (if it is caused by improper locking semantics).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

