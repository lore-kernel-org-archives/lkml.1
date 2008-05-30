Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbYE3FAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbYE3FAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756620AbYE3E7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:59:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754428AbYE3E7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:59:07 -0400
Date: Thu, 29 May 2008 21:58:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 27/41] cpu alloc: Remove the allocpercpu functionality
Message-Id: <20080529215850.7c95356e.akpm@linux-foundation.org>
In-Reply-To: <20080530040020.139375468@sgi.com>
References: <20080530035620.587204923@sgi.com>
	<20080530040020.139375468@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 20:56:47 -0700 Christoph Lameter <clameter@sgi.com> wrote:

> There is no user of allocpercpu left after all the earlier patches were
> applied. Remove the allocpercpu code.

Wow.

y:/usr/src/25> grep alloc_percpu patches/*.patch
y:/usr/src/25> 

we might just be able to get away with doing this.

But it might make life easier to defer the removal of the old stuff for
a while.  This can be worked out later.

