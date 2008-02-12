Return-Path: <linux-kernel-owner+w=401wt.eu-S1761635AbYBLIDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761635AbYBLIDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbYBLIDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:03:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbYBLIDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:03:03 -0500
Date: Tue, 12 Feb 2008 16:00:53 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
       Jonathan Corbet <corbet@lwn.net>, torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: tidy up follow_hugetlb_page() and get_user_pages()
Message-ID: <20080212080053.GA12805@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
References: <20080212052840.GA3942@kernel.sg> <20080211234720.972574ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211234720.972574ea.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<quote sender="Andrew Morton">
> On Tue, 12 Feb 2008 13:28:40 +0800 Eugene Teo <eugeneteo@kernel.sg> wrote:
> 
> > This patch extends Jonathan Corbet's patch to avoid buffer overflows in
> > get_user_pages(). It cleans up follow_hugetlb_page(), and get_user_pages() so
> > that it is easier to read. It also makes sure that len and vma are validated.
> 
> We'd prefer that the functional change not be bundled with a (large) cleanup, please.

Ok. I will split them up, and resend.

Thanks,
Eugene
