Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbZFWNny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbZFWNny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759034AbZFWNnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:43:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42053 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbZFWNnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:43:45 -0400
Date: Tue, 23 Jun 2009 10:42:34 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, mel@csn.ul.ie, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       htd@fancy-poultry.org
Subject: Re: [PATCH 3/3] net-dccp: Suppress warning about large allocations
	from DCCP
Message-ID: <20090623134234.GE2721@ghostprotocols.net>
References: <20090623023936.GA2721@ghostprotocols.net> <20090622.211927.245716932.davem@davemloft.net> <4A40B69A.2020703@gmail.com> <20090623.040551.37741458.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623.040551.37741458.davem@davemloft.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jun 23, 2009 at 04:05:51AM -0700, David Miller escreveu:
> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Tue, 23 Jun 2009 13:03:54 +0200
> 
> > But it has some bootmem references, it might need more work than
> > just exporting it.
> 
> In that case we should probably just apply the original patch
> for now, and leave this cleanup as a future change.

Full circle! That was my suggestion as well :-)

- Arnaldo
