Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYAHBrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYAHBrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 20:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYAHBrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 20:47:17 -0500
Received: from kanga.kvack.org ([66.96.29.28]:58004 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYAHBrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 20:47:16 -0500
Date: Mon, 7 Jan 2008 20:47:01 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       David Miller <davem@davemloft.net>
Subject: Re: regression: sysctl_check changes in 2.6.24 are O(n) resulting in slow creation of 10000 network interfaces
Message-ID: <20080108014701.GI28570@kvack.org>
References: <20080106220307.GU28570@kvack.org> <m1ir26ktqi.fsf@ebiederm.dsl.xmission.com> <20080106.231040.222338659.davem@davemloft.net> <m1tzlqj5kz.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tzlqj5kz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 03:25:00AM -0700, Eric W. Biederman wrote:
> I think someone failed to notice that using /proc/sys slowed to a crawl
> in that event, and now that I am doing a lookup on register it seems to
> showing up in the benchmarks.

The directory that is problematic rarely gets accessed.  Fixing sysfs 
properly at some point would be a good idea, it's just one of those things 
that isn't quite high priority yet.

> Benjamin can you test the patch below and tell me if it also
> keeps the network device performance at acceptable levels.

I can confirm that this patch does indeed put the regression at bay for 
now.

		-ben
