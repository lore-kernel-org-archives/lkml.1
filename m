Return-Path: <linux-kernel-owner+w=401wt.eu-S933142AbXCZAFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142AbXCZAFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 20:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933156AbXCZAFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 20:05:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:42460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933142AbXCZAFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 20:05:16 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 26 Mar 2007 10:05:02 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17927.3630.414133.365527@notabene.brown>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] add file position info to proc
In-Reply-To: message from Andrew Morton on Sunday March 25
References: <E1HVELJ-0006ed-00@dorka.pomaz.szeredi.hu>
	<20070325154541.6dcbd291.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday March 25, akpm@linux-foundation.org wrote:
> On Sat, 24 Mar 2007 23:04:09 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > This patch adds support for finding out the current file position,
> > open flags and possibly other info in the future.
> > 
> > These new entries are added:
> > 
> >   /proc/PID/fdinfo/FD
> >   /proc/PID/task/TID/fdinfo/FD
> > 
> > For each fd the information is provided in the following format:
> > 
> > pos:	1234
> > flags:	0100002
> 
> I've seen the idea mentioned once or twice, but not with any great
> enthusiasm.  Why does Linux want this feature?

Same reason we want ltrace and lsof.  To be able to look inside a
process and see what it is doing.
e.g. how far has that program got through reading that enormous file?
is it really making progress, or is it going much more slowly than I
would expect and so should I look more deeply.

I'm in favour.

NeilBrown
