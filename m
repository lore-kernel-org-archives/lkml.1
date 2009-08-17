Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZHQNxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZHQNxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 09:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZHQNxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 09:53:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39469 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZHQNxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 09:53:41 -0400
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] Add pseudo-anonymous huge page mappings V3
From: Andi Kleen <andi@firstfloor.org>
References: <cover.1250258125.git.ebmunson@us.ibm.com>
Date: Mon, 17 Aug 2009 15:53:41 +0200
In-Reply-To: <cover.1250258125.git.ebmunson@us.ibm.com> (Eric B. Munson's message of "Fri, 14 Aug 2009 15:08:46 +0100")
Message-ID: <87d46usg0q.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric B Munson <ebmunson@us.ibm.com> writes:

> This patch set adds a flag to mmap that allows the user to request
> a mapping to be backed with huge pages.  This mapping will borrow
> functionality from the huge page shm code to create a file on the
> kernel internal mount and uses it to approximate an anonymous
> mapping.  The MAP_HUGETLB flag is a modifier to MAP_ANONYMOUS
> and will not work without both flags being preset.


You seem to have forgotten to describe WHY you want this?

>From my guess, this seems to be another step into turning hugetlb.c
into another parallel VM implementation. Instead of basically
developing two parallel VMs wouldn't it be better to unify the two?

I think extending hugetlb.c forever without ever thinking about
that is not the right approach.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
