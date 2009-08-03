Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZHCPVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZHCPVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 11:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZHCPVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 11:21:51 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:49124 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbZHCPVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 11:21:49 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH] fcntl: F_[SG]ETOWN_TID
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oleg@redhat.com, eranian@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
In-Reply-To: <20090731141122.a1939712.akpm@linux-foundation.org>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	 <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com>
	 <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com>
	 <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com>
	 <1249029320.6391.72.camel@twins>
	 <20090731141122.a1939712.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 17:21:33 +0200
Message-Id: <1249312893.7924.108.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-31 at 14:11 -0700, Andrew Morton wrote:
> 
> 
> > arch/parisc/include/asm/fcntl.h |    2 +
> > fs/fcntl.c                      |   64 +++++++++++++++++++++++++++++++++-----
> > include/asm-generic/fcntl.h     |    4 ++
> > include/linux/fs.h              |   11 +++++-
> > net/socket.c                    |    2 +-
> 
> OK.
> 
> 
> 
> Alpha has private definitions of F_SETSIG and F_GETSIG which are
> identical to the generic ones.  That's somewhat logical, given that
> alpha's F_SETOWN/F_GETOWN _differ_ from the asm-generic ones.
> 
> Alpha appears to have made the decision to spell out _all_ the F_*
> flags, given that some of them are different.  That has some merit, I
> guess.
> 
> But your patch broke that.

Right, all I did was validate that I didn't overlap with any of the
existing fcntl numbers. I can explicitly add them to alpha if that makes
people happy..



