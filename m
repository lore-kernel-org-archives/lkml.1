Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbZFLNpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbZFLNpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765022AbZFLNkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:40:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:34227 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764045AbZFLNkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:40:18 -0400
Subject: Re: [GIT PULL] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       npiggin@suse.de, yinghai@kernel.org
In-Reply-To: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 23:38:15 +1000
Message-Id: <1244813895.7172.157.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 16:25 +0300, Pekka J Enberg wrote:

> +	/* Lets avoid crashing in early boot code. */
> +	if (WARN_ON_ONCE((local_flags & ~slab_gfp_mask) != 0))
> +		local_flags &= slab_gfp_mask;
> +

I still object to the WARN_ON, see all the previous discussions on that
subject...

Cheers,
Ben.


