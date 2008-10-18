Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbYJRWtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbYJRWtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 18:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbYJRWtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 18:49:14 -0400
Received: from styx.suse.cz ([82.119.242.94]:60072 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750878AbYJRWtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 18:49:13 -0400
Date: Sun, 19 Oct 2008 00:49:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: James Courtier-Dutton <James@superbug.co.uk>
cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, agospoda@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <48FA3545.3030102@superbug.co.uk>
Message-ID: <alpine.LNX.1.10.0810190042420.27479@jikos.suse.cz>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com> <48FA3545.3030102@superbug.co.uk>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Oct 2008, James Courtier-Dutton wrote:

> > Many of the reports seem to be related in time to a graphics crash, no one 
> > has been able to give us more detail about how to reproduce.  We NEED HELP 
> > reproducing this.  Steps, hints, anything.  We are trying rebooting, 
> > suspending, opensuse, fedora, ubuntu, and several hardware platforms, etc.
> I would suspect the ipv6 module instead of the graphics. It has a number 
> of bugs in it. I am just mentioning it in case it helps.

The culprit of the bug has already been identified. It has been 
CONFIG_DYNAMIC_FTRACE.

-- 
Jiri Kosina
SUSE Labs
