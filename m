Return-Path: <linux-kernel-owner+w=401wt.eu-S932848AbXB1ObU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbXB1ObU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932864AbXB1ObU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:31:20 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:46504
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932848AbXB1ObT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:31:19 -0500
Message-Id: <45E5A05F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Wed, 28 Feb 2007 14:31:43 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Hugh Dickins" <hugh@veritas.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: struct page field arrangement
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A change early last year reordered struct page so that ptl overlaps not only
private, but also mapping. Since spinlock_t can be much larger, I'm wondering
whether there's a reason to not also overlay the space index and lru take -
are these used for anything on page table pages?

Thanks, Jan
