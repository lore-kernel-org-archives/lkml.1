Return-Path: <linux-kernel-owner+w=401wt.eu-S964926AbZGQQfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964926AbZGQQfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 12:35:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964917AbZGQQfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 12:35:08 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:48299 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S964908AbZGQQfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 12:35:07 -0400
Date: Fri, 17 Jul 2009 12:34:49 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] add isolate pages vmstat
In-Reply-To: <20090717085821.A900.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0907171234130.11303@gentwo.org>
References: <20090716095344.9D10.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907161024120.32382@gentwo.org> <20090717085821.A900.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009, KOSAKI Motohiro wrote:

> > Why do a separate pass over all the migrates pages? Can you add the
> > _inc_xx  somewhere after the page was isolated from the lru by calling
> > try_to_unmap()?
>
> calling try_to_unmap()? the pages are isolated before calling migrate_pages().
> migrate_pages() have multiple caller. then I put this __inc_xx into top of
> migrate_pages().

Then put the inc_xxx's where the pages are isolated.
