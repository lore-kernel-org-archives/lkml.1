Return-Path: <linux-kernel-owner+w=401wt.eu-S1750964AbXEDMjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964AbXEDMjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 08:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXEDMjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 08:39:43 -0400
Received: from pat.uio.no ([129.240.10.15]:35058 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbXEDMjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 08:39:42 -0400
Subject: Re: [GIT] NFS client updates for 2.6.22...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Tomasz =?UTF-8?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
In-Reply-To: <Pine.BSO.4.63.0705021705110.11088@rudy.mif.pg.gda.pl>
References: <1178117571.5435.10.camel@heimdal.trondhjem.org>
	 <Pine.BSO.4.63.0705021705110.11088@rudy.mif.pg.gda.pl>
Content-Type: text/plain; charset=utf-8
Date: Fri, 04 May 2007 05:39:38 -0700
Message-Id: <1178282378.6346.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 8BIT
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.141)
X-UiO-Scanned: 791910DA7D1690E3B80A9FEF755CFCCA0E31E194
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1318 total 1511427 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 17:12 +0200, Tomasz Kłoczko wrote:
> On Wed, 2 May 2007, Trond Myklebust wrote:
> [..]
> 
> Trond .. any chance for implement clear NFS statistics part of kernel 
> code for "nfsstat -z" ?
> 
> kloczek

That can be done in userland: make 'nfsstat -z' save a copy of the
current /proc/net/rpc/nfs so that it can subtract those values in later
calls to nfsstat.

Cheers
  Trond

