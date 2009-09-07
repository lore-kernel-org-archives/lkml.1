Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZIGHgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZIGHgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 03:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbZIGHgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 03:36:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZIGHgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 03:36:36 -0400
Date: Mon, 7 Sep 2009 09:36:38 +0200
From: Nick Piggin <npiggin@suse.de>
To: Daniel Walker <dwalker@fifo99.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/33] fs: dcache scale nr_dentry
Message-ID: <20090907073638.GE1875@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net> <20090904065535.121108656@nick.local0.net> <1252075262.22928.9.camel@desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252075262.22928.9.camel@desktop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 07:41:02AM -0700, Daniel Walker wrote:
> On Fri, 2009-09-04 at 16:51 +1000, npiggin@suse.de wrote:
> > plain text document attachment (fs-dcache-scale-nr_dentry.patch)
> > Make dentry_stat_t.nr_dentry an atomic_t type, and move it from under
> > dcache_lock.
> > ---
> >  fs/dcache.c            |   20 +++++++++-----------
> >  include/linux/dcache.h |    4 ++--
> >  kernel/sysctl.c        |    6 ++++++
> >  3 files changed, 17 insertions(+), 13 deletions(-)
> > 
> 
> No sign off on this one..

Ah, yeah... They're not really signoffable quality. Even a bit too
raw (not enough comments) for detailed review. I just want to get
the high level design out there again for comments because it is a
really big time investment to go further...

Just want to see if I make anyone upset or there are some bright
ideas of how to improve things :)

