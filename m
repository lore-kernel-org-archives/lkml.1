Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYCWAXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYCWAXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 20:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYCWAWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 20:22:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34527
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbYCWAWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 20:22:51 -0400
Date: Sat, 22 Mar 2008 17:23:05 -0700 (PDT)
Message-Id: <20080322.172305.103826809.davem@davemloft.net>
To: fujita.tomonori@lab.ntt.co.jp
Cc: linux-kernel@vger.kernel.org, linux-sparc@vger.kernel.org, tomof@acm.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm 1/2] SPARC64: add the segment boundary checking to
 IOMMUs while merging SG entries
From: David Miller <davem@davemloft.net>
In-Reply-To: <1205380027-28230-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205380027-28230-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 13 Mar 2008 12:47:06 +0900

> Some IOMMUs allocate memory areas spanning LLD's segment boundary
> limit. It forces low level drivers to have a workaround to adjust
> scatter lists that the IOMMU builds. We are in the process of making
> all the IOMMUs respect the segment boundary limits to remove such work
> around in LLDs.
> 
> SPARC64 IOMMUs were rewritten to use the IOMMU helper functions and
> the commit 89c94f2f70d093f59b55d3ea8042d13889169346 made the IOMMUs
> not allocate memory areas spanning the segment boundary limit.
> 
> However, SPARC64 IOMMUs allocate memory areas first then try to merge
> them (while some IOMMUs walk through all the sg entries to see how
> they can be merged first and allocate memory areas). So SPARC64 IOMMUs
> also need the boundary limit checking when they try to merge sg
> entries.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: David S. Miller <davem@davemloft.net>
