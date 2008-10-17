Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYJQQ5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYJQQ5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 12:57:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbYJQQ5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 12:57:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52022 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbYJQQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 12:57:39 -0400
Date: Fri, 17 Oct 2008 12:57:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: sleeping function called from invalid context at
	kernel/rwsem.c:131 XFS? (was: Re: linux-next: Tree for October 17)
Message-ID: <20081017165738.GA20818@infradead.org>
References: <a4423d670810170543vd6b4c39p44bf125610d8540@mail.gmail.com> <20081017164116.GA17375@infradead.org> <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670810170954h7ca130aaw8895380a4c6b125@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 08:54:35PM +0400, Alexander Beregalov wrote:
> Workload is not specific, many i/o commands trigger the message.
> 
>  dmesg|grep comm:
> [    4.419605] Pid: 1396, comm: mkdir Not tainted 2.6.27-next-20081017 #2
> [    6.056443] Pid: 1782, comm: dhcpcd Not tainted 2.6.27-next-20081017 #2
> [   17.899905] Pid: 1791, comm: dhcpcd-run-hook Not tainted
> 2.6.27-next-20081017 #2
> [ 3846.588549] Pid: 2005, comm: screen Not tainted 2.6.27-next-20081017 #2
> [ 4416.242723] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
> [ 4430.618037] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
> [ 4431.641578] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
> [ 4432.944265] Pid: 2023, comm: git Not tainted 2.6.27-next-20081017 #2
> [ 4590.330706] Pid: 2026, comm: git-merge Not tainted 2.6.27-next-20081017 #2
> [14882.802479] Pid: 2058, comm: git-merge Not tainted 2.6.27-next-20081017 #2
> [16955.026436] Pid: 2091, comm: git-merge Not tainted 2.6.27-next-20081017 #2
> [18466.645935] Pid: 2119, comm: git-merge Not tainted 2.6.27-next-20081017 #2
> [19165.813049] Pid: 2150, comm: git-merge Not tainted 2.6.27-next-20081017 #2

Very strange.  Can you retry with tomorrow Linux-next which should have
a large XFS update?  If it still happens I'll investigate it in more
detail.
