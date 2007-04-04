Return-Path: <linux-kernel-owner+w=401wt.eu-S966326AbXDDMcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966326AbXDDMcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 08:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966327AbXDDMcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 08:32:52 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:56584 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966326AbXDDMcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 08:32:52 -0400
To: a.p.zijlstra@chello.nl
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com
In-reply-to: <1175688356.6483.81.camel@twins> (message from Peter Zijlstra on
	Wed, 04 Apr 2007 14:05:56 +0200)
Subject: Re: [PATCH 6/6] mm: per device dirty threshold
References: <20070403144047.073283598@taijtu.programming.kicks-ass.net>
	 <20070403144224.709586192@taijtu.programming.kicks-ass.net>
	 <E1HZ1so-0005q8-00@dorka.pomaz.szeredi.hu> <1175681794.6483.43.camel@twins>
	 <E1HZ2kU-0005xx-00@dorka.pomaz.szeredi.hu> <1175684461.6483.64.camel@twins>
	 <E1HZ3Q9-00062G-00@dorka.pomaz.szeredi.hu> <1175688356.6483.81.camel@twins>
Message-Id: <E1HZ4ep-00069u-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Apr 2007 14:32:11 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Preferably you'd want to be able to 'flush' the per cpu diffs or
> something like that in cases where thresh ~< NR_CPUS * stat_diff.
> 
> How about something like this:

Yes, maybe underscores and EXPORT_SYMBOLs are a bit excessive.

Miklos
