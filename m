Return-Path: <linux-kernel-owner+w=401wt.eu-S1765779AbYCFNLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765779AbYCFNLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYCFNLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:11:05 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54272 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbYCFNLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:11:04 -0500
Date: Thu, 6 Mar 2008 14:12:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Cyrus Massoumi <cyrusm@gmx.net>,
       Diego Calleja <diegocg@gmail.com>, Stephen Cuppett <cuppett@gmail.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: Performance versus FreeBSD 7.0
Message-ID: <20080306131230.GA24689@one.firstfloor.org>
References: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com> <47CC4B3F.8060405@gmx.net> <p73y78z5r3k.fsf@bingen.suse.de> <200803062353.07298.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803062353.07298.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think since the mmap_sem madvise problem was solved, the kernel
> didn't really have any further problems with this workload.

Good.

> It is doing a lot of context switches, no IO, and not a lot of

Yes sysbench is a pretty poor benchmark i think, especially
on systems with a lot of cores. I ran into this on some of my
own testing too. I don't think it makes too much
sense to tune for it seriously, but of course it doesn't hurt
when Linux does well on it anyways.

-Andi
