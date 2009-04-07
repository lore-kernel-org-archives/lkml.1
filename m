Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbZDGE2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbZDGE2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbZDGE20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:28:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751202AbZDGE20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:28:26 -0400
Date: Mon, 6 Apr 2009 21:25:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: mmotm 2009-04-05-21-45 uploaded (sysctl)
Message-Id: <20090406212539.13d28f16.akpm@linux-foundation.org>
In-Reply-To: <49DAD2AA.9000604@oracle.com>
References: <200904060450.n364oaUj031923@imap1.linux-foundation.org>
	<20090406210921.9efab09b.randy.dunlap@oracle.com>
	<49DAD2AA.9000604@oracle.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Apr 2009 21:12:26 -0700 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Randy Dunlap wrote:
> > On Sun, 05 Apr 2009 21:50:36 -0700 akpm@linux-foundation.org wrote:
> > 
> >> The mm-of-the-moment snapshot 2009-04-05-21-45 has been uploaded to
> >>
> >>    http://userweb.kernel.org/~akpm/mmotm/
> >>
> >> and will soon be available at
> >>
> >>    git://git.zen-sources.org/zen/mmotm.git
> >>
> >> It contains the following patches against 2.6.29:
> > 
> > 
> > kernel/sysctl.c: In function '__register_sysctl_paths':
> > kernel/sysctl.c:2059: error: 'struct ctl_table_header' has no member named 'dep_map'
> > 
> > 
> > config attached.
> > 
> > ---
> > ~Randy
> 
> kernel/sysctl.c: s/CONFIG_DEBUG_LOCK_ALLOC/CONFIG_PROVE_LOCKING/ at line 2056.

OK, thanks, sysctl-lockdep-support-for-sysctl-reference-counting.patch.

I have a note here that Peter had issues with that patch anyway.  I'm
not yet sure if it's due to be fixed or dropped or what?

