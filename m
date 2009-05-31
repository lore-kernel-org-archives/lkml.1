Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbZEaPO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbZEaPO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 11:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbZEaPOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 11:14:21 -0400
Received: from fifo99.com ([67.223.236.141]:54369 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbZEaPOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 11:14:21 -0400
Subject: Re: [PATCH 4/8] kernel:lockdep:implement find_usage_*wards by BFS
From: Daniel Walker <dwalker@fifo99.com>
To: tom.leiming@gmail.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl
In-Reply-To: <1243781365-26814-5-git-send-email-tom.leiming@gmail.com>
References: <yes> <1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
	 <1243781365-26814-2-git-send-email-tom.leiming@gmail.com>
	 <1243781365-26814-3-git-send-email-tom.leiming@gmail.com>
	 <1243781365-26814-4-git-send-email-tom.leiming@gmail.com>
	 <1243781365-26814-5-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain
Date: Sun, 31 May 2009 08:14:21 -0700
Message-Id: <1243782861.6592.415.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-31 at 22:49 +0800, tom.leiming@gmail.com wrote:
> -static inline int __bfs_forward(struct lock_list *src_entry,
> +static inline int __bfs_forwards(struct lock_list *src_entry,

Your patchset seems a bit young still .. For instance, adding an "s" in
the above line, that's just flux that really shouldn't be there.. I was
reviewing your patches but I stopped because it just looks like you need
to organize them better. I wonder for one, if they bisect or if they
pass checkpatch .. Your code also seems to have a lot of other little
cleanup type issues..

Daniel

