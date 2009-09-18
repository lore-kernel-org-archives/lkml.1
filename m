Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbZIRAq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbZIRAq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 20:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbZIRAq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 20:46:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbZIRAq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 20:46:26 -0400
Date: Thu, 17 Sep 2009 17:46:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebmunson@us.ibm.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com,
       randy.dunlap@oracle.com, rth@twiddle.net, ink@jurassic.park.msu.ru
Subject: Re: [PATCH 2/3] Add MAP_HUGETLB for mmaping pseudo-anonymous huge
 page regions
Message-Id: <20090917174616.f64123fb.akpm@linux-foundation.org>
In-Reply-To: <20090917154404.e1d3694e.akpm@linux-foundation.org>
References: <cover.1251197514.git.ebmunson@us.ibm.com>
	<25614b0d0581e2d49e1024dc1671b282f193e139.1251197514.git.ebmunson@us.ibm.com>
	<8504342f7be19e416ef769d1edd24b8549f8dc39.1251197514.git.ebmunson@us.ibm.com>
	<20090917154404.e1d3694e.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 15:44:04 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> mm/mmap.c: In function 'do_mmap_pgoff':
> mm/mmap.c:953: error: 'MAP_HUGETLB' undeclared (first use in this function)

mips breaks as well.

I don't know how many other architectures broke.  I disabled the patches.
