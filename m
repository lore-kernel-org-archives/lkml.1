Return-Path: <linux-kernel-owner+w=401wt.eu-S1757625AbXKKS3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbXKKS3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 13:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756725AbXKKS3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 13:29:12 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:45934 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbXKKS3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 13:29:11 -0500
Date: Sun, 11 Nov 2007 19:29:09 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, wfg@mail.ustc.edu.cn
Subject: Re: Temporary lockup on loopback block device
In-Reply-To: <E1Ir7al-0004Tm-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0711111926070.19188@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0711102025440.17691@artax.karlin.mff.cuni.cz> 
 <20071110145444.a6993df1.akpm@linux-foundation.org> <1194735752.5828.1.camel@lappy>
 <Pine.LNX.4.64.0711110135450.18189@artax.karlin.mff.cuni.cz>
 <E1Ir7al-0004Tm-00@dorka.pomaz.szeredi.hu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Why are there over-limit dirty pages that no one is writing?
> 
> Please do a sysrq-t, and cat /proc/vmstat during the hang.  Those
> will show us what exactly is happening.

I did and I posted relevant information from my finding --- it looped in 
balance_dirty_pages.

> I've seen this type of hang many times, and I agree with Peter, that
> it's probably about loopback, and is fixed in 2.6.24-rc.

On 2.6.23 it could happen even without loopback --- loopback just made it 
happen very often. 2.6.24 seems ok.

Mikulas

> Thanks,
> Miklos
> 
> 
