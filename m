Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZLBODD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZLBODD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbZLBODD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:03:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43400 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZLBODC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 09:03:02 -0500
Date: Wed, 2 Dec 2009 15:03:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/24] HWPOISON: make it possible to unpoison pages
Message-ID: <20091202140305.GL18989@one.firstfloor.org>
References: <20091202031231.735876003@intel.com> <20091202043045.150526892@intel.com> <20091202131530.GG18989@one.firstfloor.org> <20091202134645.GA19274@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202134645.GA19274@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> btw, do you feel comfortable with the interface name "renew-pfn"?
> (versus "unpoison-pfn")

I prefer unpoison, that makes it clear what it is.

Maybe even call it "software_unpoison_pfn", because it won't unpoison on the 
hardware level (this really should be documented somewhere too)

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
