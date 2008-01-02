Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbYABWn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbYABWn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 17:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754063AbYABWnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 17:43:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbYABWnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 17:43:49 -0500
Message-ID: <477C138B.6080803@redhat.com>
Date: Wed, 02 Jan 2008 16:43:23 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
References: <20080102013218.GO27566@does.not.exist> <20080102174157.GD3351@webber.adilger.int> <20080102195146.GB15898@does.not.exist>
In-Reply-To: <20080102195146.GB15898@does.not.exist>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Most people and all distributions use CONFIG_EXPERIMENTAL=y simply 
> because too many options (including options required for hardware 
> support) depend on it.
> 
> Compare e.g.:
> - "Marvell SATA support (HIGHLY EXPERIMENTAL)"
> - "Provide NFSv4 client support (EXPERIMENTAL)"
> - "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"

       tristate "Snapshot target (EXPERIMENTAL)"
       depends on BLK_DEV_DM && EXPERIMENTAL

       tristate "Mirror target (EXPERIMENTAL)"
       depends on BLK_DEV_DM && EXPERIMENTAL

...

It does seem that it might be a good goal to revisit options marked
EXPERIMENTAL, and see if they still should be marked as such, rather
than removing the option altogether.

init/Kconfig describes things in "EXPERIMENTAL" as "alpha-test" - I bet
there are a few things which have moved beyond this, but are still
marked as such.

-Eric


