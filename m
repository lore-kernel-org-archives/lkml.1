Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZGKS0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZGKS0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 14:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbZGKS0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 14:26:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbZGKSZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 14:25:59 -0400
Date: Sat, 11 Jul 2009 11:25:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: -tip: block, mm: Fix build error in mm/memcontrol.c
In-Reply-To: <20090711065152.GA23336@elte.hu>
Message-ID: <alpine.LFD.2.01.0907111125030.3552@localhost.localdomain>
References: <20090711065152.GA23336@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 11 Jul 2009, Ingo Molnar wrote:
> 
> Today's upstream tree build (x86, 64-bit, allyesconfig) failed with 
> this build error:

I merged a better fix from Trond, which should make all of this 
unnecessary (just move BLK_RW_[A]SYNC to the header file that people need 
anyway).

		Linus
