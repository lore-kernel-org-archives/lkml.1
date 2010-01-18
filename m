Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193Ab0ARP52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab0ARP52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 10:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006Ab0ARP51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 10:57:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:36057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab0ARP51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 10:57:27 -0500
Date: Mon, 18 Jan 2010 16:57:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Kasper Sandberg <lkml@metanurb.dk>
Cc: Oliver Neukum <oliver@neukum.org>, smurf@smurf.noris.de,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: option driver freezing entire system
In-Reply-To: <1263580615.27788.134.camel@localhost>
Message-ID: <alpine.LRH.2.00.1001181656500.15694@twin.jikos.cz>
References: <1263577116.27788.131.camel@localhost>  <201001151855.46217.oliver@neukum.org> <1263580615.27788.134.camel@localhost>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010, Kasper Sandberg wrote:

> > Please recompile your kernel with lockdep. This should improve
> > debugging.
> 
> It is a debian unstable .32 kernel i run now, and grepping for lockdep
> reveals:
> CONFIG_LOCKDEP_SUPPORT=y
> only, is there anything more i should have? (never used lockdep before)

CONFIG_PROVE_LOCKING could be helpful here. (be aware of the fact that 
this will make your system noticeably slower).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

