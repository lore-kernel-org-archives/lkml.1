Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbYBCPVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbYBCPVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 10:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYBCPVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 10:21:45 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49379 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbYBCPVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 10:21:44 -0500
Subject: Re: [PATCH] lockdep: Include all lock classes in all_lock_classes
From: Peter Zijlstra <peterz@infradead.org>
To: Dale Farnsworth <dale@farnsworth.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080201152106.GA21534@farnsworth.org>
References: <20080201152106.GA21534@farnsworth.org>
Content-Type: text/plain
Date: Sun, 03 Feb 2008 16:21:02 +0100
Message-Id: <1202052062.32654.69.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-01 at 08:21 -0700, Dale Farnsworth wrote:
> Add each lock class to the all_lock_classes list when it is
> first registered.
> 
> Previously, lock classes were added to all_lock_classes when
> the lock class was first used. 

> Since one of the uses of the list is to find unused locks, this didn't
> work well.

You mean in lockdep_proc.c to generate the statistics?

Another potential issue might be count_matching_names() generating a
wrong class version.



