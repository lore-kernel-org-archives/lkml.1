Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbYLaXFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbYLaXFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 18:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYLaXEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 18:04:51 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:44281 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbYLaXEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 18:04:50 -0500
Date: Wed, 31 Dec 2008 17:04:04 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Andrew Morton <akpm@linux-foundation.org>, jens.axboe@oracle.com,
       kmannth@us.ibm.com, linux-kernel@vger.kernel.org, sekharan@us.ibm.com,
       Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
       linux-fsdevel@vger.kernel.org
Subject: Defrag support for inodes / dentries etc
In-Reply-To: <84144f020812301208i34e5cc73hac25675f56e6aac0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812311657050.21595@quilx.com>
References: <1227561983.6487.32.camel@keith-laptop>  <20081125091917.GU26308@kernel.dk>
  <20081230113514.fe09d495.akpm@linux-foundation.org> 
 <20081230114138.cd9e9763.akpm@linux-foundation.org>
 <84144f020812301208i34e5cc73hac25675f56e6aac0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008, Pekka Enberg wrote:

> > I'll need to revert to yesterday's linux-next I think.  Pekka, has
> > that stuff been dropped?
>
> Yup, there hasn't been any activity after the last merge window so I'm
> not expecting to be able to merge it for 2.6.29. As per linux-next
> rules, I dropped the 2.6.30 material until the merge window closes.
> The code is in topic/slub-defrag of slab.git, though.

Well the problem currently is that there is no driver for these features.
There has been a request for this functionality for a long time but both
the primary drivers for this (Dave Chinner and I) are no longer with the
company for which we started the project. I'd be glad to continue this
if there would be an interest by the filesystem developers.

The key problem that would have to be addressed to move this
forward is to clean up the callbacks for dentries and inodes.

Again the problem solved by these patches are mainly filesystem intensive
loads that can cause significant fragmentation for inodes and denties
which may leave lots of memory unrecoverable for other purposes.





