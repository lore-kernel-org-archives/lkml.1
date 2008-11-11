Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbYKKTWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbYKKTWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 14:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYKKTWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 14:22:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57314 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbYKKTWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 14:22:08 -0500
Date: Tue, 11 Nov 2008 11:20:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, avi@redhat.com
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux
Message-Id: <20081111112043.bf1af70e.akpm@linux-foundation.org>
In-Reply-To: <4919D7DE.4000508@redhat.com>
References: <1226409701-14831-1-git-send-email-ieidus@redhat.com>
	<20081111103051.979aea57.akpm@linux-foundation.org>
	<4919D7DE.4000508@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 21:07:10 +0200
Izik Eidus <ieidus@redhat.com> wrote:

> we have used KSM in production for about half year and the numbers that 
> came from our QA is:
> using KSM for desktop (KSM was tested just for windows desktop workload) 
> you can run as many as
> 52 windows xp with 1 giga ram each on server with just 16giga ram. (this 
> is more than 300% overcommit)
> the reason is that most of the kernel/dlls of this guests is shared and 
> in addition we are sharing the windows zero
> (windows keep making all its free memory as zero, so every time windows 
> release memory we take the page back to the host)
> there is slide that give this numbers you can find at:
> http://kvm.qumranet.com/kvmwiki/KvmForum2008?action=AttachFile&do=get&target=kdf2008_3.pdf 
> (slide 27)
> beside more i gave presentation about ksm that can be found at:
> http://kvm.qumranet.com/kvmwiki/KvmForum2008?action=AttachFile&do=get&target=kdf2008_12.pdf

OK, 300% isn't chicken feed.

It is quite important that information such as this be prepared, added to
the patch changelogs and maintained.  For a start, without this basic
information, there is no reason for anyone to look at any of the code!
