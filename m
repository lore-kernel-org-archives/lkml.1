Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbZGNOcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbZGNOcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbZGNOcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:32:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:45366 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbZGNOcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:32:51 -0400
Subject: Re: [PATCH/RFC] NOMMU: drop page cache whenever any alloc fails
 due to low memory
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>,
       David Howells <dhowells@redhat.com>
In-Reply-To: <1247581357-20068-1-git-send-email-vapier@gentoo.org>
References: <1247581357-20068-1-git-send-email-vapier@gentoo.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Jul 2009 16:30:38 +0200
Message-Id: <1247581838.7500.98.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-14 at 10:22 -0400, Mike Frysinger wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Since no-mmu systems tend to be memory constrained, we want to drop all
> of the page cache whenever memory gets low.  The only other option is to
> invoke the oom killer, and clearly that's not ideal.

Uhm,.. normally reclaim will already try to drop pagecache.
