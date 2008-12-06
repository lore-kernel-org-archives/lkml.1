Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbYLFNzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbYLFNzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 08:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbYLFNzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 08:55:41 -0500
Received: from vps1.tull.net ([66.180.172.116]:35497 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753062AbYLFNzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 08:55:41 -0500
Date: Sun, 7 Dec 2008 00:55:36 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Fix incorrect use of loose in migrate.c
Message-ID: <20081206135536.GH5957@mail.local.tull.net>
References: <20081205030807.32309.69191.stgit@marcab.local.tull.net> <20081206121227.GA6292@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081206121227.GA6292@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 01:12:27PM +0100, Nick Piggin wrote:
> >  	/*
> >  	 * A dirty page may imply that the underlying filesystem has
> >  	 * the page on some queue. So the page must be clean for
> > -	 * migration. Writeout may mean we loose the lock and the
> > +	 * migration. Writeout may mean we lose the lock and the
> >  	 * page state is no longer what we checked for earlier.
> >  	 * At this point we know that the migration attempt cannot
> >  	 * be successful.
> 
> I don't know... presumably we haven't just gone and lost the little
> bugger. I mean, we were holding it one minute, then... gone?  Do we
> have Alzheimer's? Unlikely. I think we loosed it.

Loosen?

Nick.
