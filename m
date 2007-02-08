Return-Path: <linux-kernel-owner+w=401wt.eu-S1161534AbXBHIAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161534AbXBHIAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 03:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161538AbXBHIAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 03:00:16 -0500
Received: from smtp.osdl.org ([65.172.181.24]:60727 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161534AbXBHIAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 03:00:14 -0500
Date: Thu, 8 Feb 2007 00:00:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, clameter@sgi.com,
       GOTO <y-goto@jp.fujitsu.com>
Subject: Re: [BUG][PATCH] fix mempolcy's check on a system with
 memory-less-node take2
Message-Id: <20070208000001.9e303a1a.akpm@linux-foundation.org>
In-Reply-To: <200702080849.42167.ak@suse.de>
References: <20070208110606.ebf668d3.kamezawa.hiroyu@jp.fujitsu.com>
	<200702080849.42167.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 08:49:41 +0100 Andi Kleen <ak@suse.de> wrote:

> 
> > This panic(hang) was found by a numa test-set on a system with 3 nodes, where
> > node(2) was memory-less-node.
> 
> I still think it's the wrong fix -- just get rid of the memory less node.

"Let's break it even more"?

> I expect you'll likely run into more problems with that setup anyways.

What happens if he doesn't run into more problems?

