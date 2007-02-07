Return-Path: <linux-kernel-owner+w=401wt.eu-S1030604AbXBGJTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030604AbXBGJTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030608AbXBGJTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:19:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030604AbXBGJTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:19:49 -0500
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, GOTO <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@engr.sgi.com>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with memory-less-node
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
From: Andi Kleen <ak@suse.de>
Date: 07 Feb 2007 11:20:06 +0100
In-Reply-To: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <p73ejp2mfqh.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> current mempolicy just checks whether a node is online or not.
> If there is memory-less-node, mempolicy's target node can be
> invalid.
> This patch adds a check whether a node has memory or not.

IMHO there shouldn't be any memory less nodes. The architecture code
should not create them. The CPU should be assigned to a nearby node instead.
At least x86-64 ensures that.

-Andi
