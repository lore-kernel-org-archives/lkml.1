Return-Path: <linux-kernel-owner+w=401wt.eu-S1761646AbYCZARL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761646AbYCZARL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbYCZAQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:16:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47323
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758077AbYCZAQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:16:54 -0400
Date: Tue, 25 Mar 2008 17:16:49 -0700 (PDT)
Message-Id: <20080325.171649.223175755.davem@davemloft.net>
To: tony.luck@intel.com
Cc: paulus@samba.org, clameter@sgi.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: larger default page sizes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECE9E2CA@orsmsx424.amr.corp.intel.com>
References: <18408.59112.945786.488350@cargo.ozlabs.ibm.com>
	<20080325.163240.102401706.davem@davemloft.net>
	<1FE6DD409037234FAB833C420AA843ECE9E2CA@orsmsx424.amr.corp.intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>
Date: Tue, 25 Mar 2008 16:49:23 -0700

> Making an application use huge pages as heap may be simple
> (just link with a different library to provide with a different
> version of malloc()) ... code, stack, mmap'd files are all
> a lot harder to do transparently.

The kernel should be able to do this transparently, at the
very least for the anonymous page case.  It should also
be able to handle just fine chips that provide multiple
page size support, as many do.
