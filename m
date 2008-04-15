Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYDOGYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYDOGYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYDOGX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:23:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbYDOGX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:23:58 -0400
Date: Mon, 14 Apr 2008 23:23:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
Message-Id: <20080414232308.ffa4e269.akpm@linux-foundation.org>
In-Reply-To: <87lk3hwv52.fsf@basil.nowhere.org>
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	<20080412225850.704752615@symbol.fehenstaub.lan>
	<87lk3hwv52.fsf@basil.nowhere.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 18:56:57 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> Johannes Weiner <hannes@saeurebad.de> writes:
> 
> > Make free_bootmem() look up the node holding the specified address
> > range which lets it work transparently on single-node and multi-node
> > configurations.
> 
> Acked-by: Andi Kleen <andi@firstfloor.org>
> 
> This is far better than the original change it replaces and which 
> I also objected to in review.
> 

So...  do we think these two patches are sufficiently safe and important for
2.6.25?

