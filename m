Return-Path: <linux-kernel-owner+w=401wt.eu-S1161269AbXBOVCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161269AbXBOVCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:02:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161268AbXBOVCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:02:35 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:52674 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161260AbXBOVCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:02:34 -0500
Date: Thu, 15 Feb 2007 22:01:40 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: David Lang <david.lang@digitalinsight.com>
cc: David Howells <dhowells@redhat.com>, torvalds@osdl.org, akpm@osdl.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org, davej@redhat.com,
       arjan@infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing 
In-Reply-To: <Pine.LNX.4.63.0702151155330.9862@qynat.qvtvafvgr.pbz>
Message-ID: <Pine.LNX.4.64.0702152143470.14458@scrub.home>
References: <Pine.LNX.4.64.0702151530260.14458@scrub.home> 
 <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> 
 <32081.1171560770@redhat.com> <Pine.LNX.4.64.0702151901380.14458@scrub.home>
 <Pine.LNX.4.63.0702151155330.9862@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 15 Feb 2007, David Lang wrote:

> this issue, and these holes keep comeing up in discussions, why can't these
> holes be closed? I seem to remember seeing patches that would remove /dev/kmem
> being sent to the list, but they weren't accepted into the kernel (and I seem
> to remember people being against the concept of removeing them, not against
> techincal details of the patches. but this was many years ago)

1. It depends on the ratio of added code and its usefulness. I must assume 
the first patch didn't even make it to the kernel due to its size, so I 
think it's not unreasonable to explore the alternatives.
2. There are many ways to load an unauthorized module, thus you have to 
prevent any modification of the kernel not just in memory but also on 
disk.

bye, Roman
