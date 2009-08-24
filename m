Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbZHXPfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbZHXPfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 11:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZHXPfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 11:35:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50714 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZHXPfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 11:35:01 -0400
Subject: Re: [PATCH 13/15] sched: Detect child domain of NUMA (aka NODE)
 domain
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20090820134347.GB29327@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com>
	 <20090820134347.GB29327@alberich.amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Aug 2009 17:34:18 +0200
Message-Id: <1251128058.7538.299.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 15:43 +0200, Andreas Herrmann wrote:
> On multi-node processors a NUMA node might not span a socket.
> Instead a socket might span several NUMA nodes.
> 
> This patch introduces a check whether NODE domain is parent
> of MC domain and sets s_data.numa_child_level accordingly.
> (See previous patch for further details.)

right, except that the previous patch was rather cryptic :/

So you're proposing to have the NODE level depend on multi-node and then
flip NODE and CPU around?


