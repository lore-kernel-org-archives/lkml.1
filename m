Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557AbZK3LKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbZK3LKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZK3LKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:10:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:51125 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbZK3LKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:10:16 -0500
Message-ID: <4B13A7ED.9010905@kernel.org>
Date: Mon, 30 Nov 2009 20:09:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch] percpu: remove two suspicious break statements
References: <20091130091501.4507.28683.sendpatchset@localhost.localdomain>
In-Reply-To: <20091130091501.4507.28683.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 06:12 PM, Amerigo Wang wrote:
> These two break statements seem to be very suspicious,
> they are at the end of the statements inside the loop.
> Remove them.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>

That actually is correct code.  It's checking whether the first
iteration covers the whole thing.  I thought the comment there

  /* quick path, check whether all pages are already there */

explained it but looking at it again, it definitely isn't enough
unless you already know what's going on there.  Can you please post a
patch to add the comment?

Thanks.

-- 
tejun
