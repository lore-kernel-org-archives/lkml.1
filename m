Return-Path: <linux-kernel-owner+w=401wt.eu-S1760442AbZJMPom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760442AbZJMPom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760409AbZJMPoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:44:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35936 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760388AbZJMPod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:44:33 -0400
Date: Tue, 13 Oct 2009 17:43:56 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       Izik Eidus <ieidus@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwpoison: fix oops on ksm pages
Message-ID: <20091013154356.GA2127@basil.fritz.box>
References: <Pine.LNX.4.64.0910131451280.4698@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910131451280.4698@sister.anvils>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 03:02:11PM +0100, Hugh Dickins wrote:
> Memory failure on a KSM page currently oopses on its NULL anon_vma in
> page_lock_anon_vma(): that may not be much worse than the consequence
> of ignoring it, but it is better to be consistent with how ZERO_PAGE
> and hugetlb pages and other awkward cases are treated.  Just skip it.

Thanks, Hugh. I'm curious: did this come out of code review or
did you actually run into that?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
