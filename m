Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYCXVqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYCXVqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 17:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbYCXVqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 17:46:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40514
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753083AbYCXVqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 17:46:30 -0400
Date: Mon, 24 Mar 2008 14:46:29 -0700 (PDT)
Message-Id: <20080324.144629.137399000.davem@davemloft.net>
To: tony.luck@intel.com
Cc: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: larger default page sizes...
From: David Miller <davem@davemloft.net>
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECE5B88C@orsmsx424.amr.corp.intel.com>
References: <Pine.LNX.4.64.0803241121090.3002@schroedinger.engr.sgi.com>
	<20080324.133722.38645342.davem@davemloft.net>
	<1FE6DD409037234FAB833C420AA843ECE5B88C@orsmsx424.amr.corp.intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>
Date: Mon, 24 Mar 2008 14:25:11 -0700

> When memory capacity is measured in hundreds of GB, then
> a larger page size doesn't look so ridiculous.

We have hugepages and such for a reason.  And this can be
made more dynamic and flexible, as needed.

Increasing the page size is a "stick your head in the sand"
type solution by my book.

Especially when you can make the hugepage facility stronger
and thus get what you want without the memory wastage side
effects.
