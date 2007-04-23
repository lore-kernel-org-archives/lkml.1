Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbXDWPs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbXDWPs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 11:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbXDWPs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 11:48:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42896 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753863AbXDWPs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 11:48:26 -0400
Date: Mon, 23 Apr 2007 08:48:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com
Subject: Re: [PATCH 10/10] mm: per device dirty threshold
In-Reply-To: <1177157708.2934.100.camel@lappy>
Message-ID: <Pine.LNX.4.64.0704230847400.10624@schroedinger.engr.sgi.com>
References: <20070420155154.898600123@chello.nl>  <20070420155503.608300342@chello.nl>
  <20070421025532.916b1e2e.akpm@linux-foundation.org>  <1177156902.2934.96.camel@lappy>
 <1177157708.2934.100.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007, Peter Zijlstra wrote:

> > > This is enormously wrong for CONFIG_NR_CPUS=1024 on a 2-way.
> 
> Right, I knew about that but, uhm.
> 
> I wanted to make that num_online_cpus(), and install a hotplug notifier
> to fold the percpu delta back into the total on cpu offline.

Use nr_cpu_ids instead. Contains the maximum possible cpus on this 
hardware and allows to handle the hotplug case easily.

