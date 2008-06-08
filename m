Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbYFHUMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbYFHUMS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbYFHUMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:12:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481AbYFHUMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:12:08 -0400
Date: Sun, 8 Jun 2008 13:12:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kosaki.motohiro@jp.fujitsu.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] add throttle to shrink_zone()
Message-Id: <20080608131203.e8cd69b7.akpm@linux-foundation.org>
In-Reply-To: <20080605021505.306358710@jp.fujitsu.com>
References: <20080605021211.871673550@jp.fujitsu.com>
	<20080605021505.306358710@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2008 11:12:15 +0900 kosaki.motohiro@jp.fujitsu.com wrote:

> add throttle to shrink_zone() for performance improvement and prevent incorrect oom.

We should have a description of how all this works, please.  I thought
that was present in earlier iterations of this patchset.

It's quite hard and quite unreliable to reverse engineer both the
design and your thinking from the implementation.

