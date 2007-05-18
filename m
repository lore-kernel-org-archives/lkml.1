Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbXERVEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbXERVEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbXERVE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:04:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40175 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753152AbXERVE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:04:27 -0400
Date: Fri, 18 May 2007 14:04:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, dgc@sgi.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 08/10] shmem: inode defragmentation support
In-Reply-To: <Pine.LNX.4.61.0705182233120.9015@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0705181403370.13256@schroedinger.engr.sgi.com>
References: <20070518181040.465335396@sgi.com> <20070518181120.477184338@sgi.com>
 <Pine.LNX.4.61.0705182233120.9015@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, Jan Engelhardt wrote:

> Do we need *this*? (compare procfs)
> 
> I believe that shmfs's inodes remain "more" in memory than those of
> procfs. That is, procfs ones can find their way out (we can regenerate
> it), while shmfs/tmpfs/ramfs/etc. should not do that (we'd lose the
> file).

Ahh... Okay so shmem inodes are not defraggable.

