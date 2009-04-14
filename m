Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZDNWP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZDNWP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZDNWPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:15:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbZDNWPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:15:09 -0400
Date: Tue, 14 Apr 2009 15:09:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Izik Eidus <ieidus@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com,
       mtosatti@redhat.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com,
       ieidus@redhat.com
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux v3
Message-Id: <20090414150903.b01fa3b9.akpm@linux-foundation.org>
In-Reply-To: <1239249521-5013-1-git-send-email-ieidus@redhat.com>
References: <1239249521-5013-1-git-send-email-ieidus@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Apr 2009 06:58:37 +0300
Izik Eidus <ieidus@redhat.com> wrote:

> KSM is a linux driver that allows dynamicly sharing identical memory
> pages between one or more processes.

Generally looks OK to me.  But that doesn't mean much.  We should rub
bottles with words like "hugh" and "nick" on them to be sure.


>
> ...
>
>  include/linux/ksm.h          |   48 ++
>  include/linux/miscdevice.h   |    1 +
>  include/linux/mm.h           |    5 +
>  include/linux/mmu_notifier.h |   34 +
>  include/linux/rmap.h         |   11 +
>  mm/Kconfig                   |    6 +
>  mm/Makefile                  |    1 +
>  mm/ksm.c                     | 1674 ++++++++++++++++++++++++++++++++++++++++++
>  mm/memory.c                  |   90 +++-
>  mm/mmu_notifier.c            |   20 +
>  mm/rmap.c                    |  139 ++++

And it's pretty unobtrusive for what it is.  I expect we can get this
into 2.6.31 unless there are some pratfalls which I missed.

