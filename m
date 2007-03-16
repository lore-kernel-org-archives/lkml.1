Return-Path: <linux-kernel-owner+w=401wt.eu-S1752878AbXCPDUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbXCPDUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 23:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXCPDUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 23:20:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:51466 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbXCPDUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 23:20:49 -0400
Date: Thu, 15 Mar 2007 19:20:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/3] Lumpy Reclaim V5
Message-Id: <20070315192038.82933a2f.akpm@linux-foundation.org>
In-Reply-To: <exportbomb.1173723760@pinky>
References: <exportbomb.1173723760@pinky>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2007 18:22:45 +0000 Andy Whitcroft <apw@shadowen.org> wrote:

> Following this email are three patches which represent the
> current state of the lumpy reclaim patches; collectively lumpy V5.

So where do we stand with this now?    Does it make anything get better?

I (continue to) think that if this is to be truly useful, we need some way
of using it from kswapd to keep a certain minimum number of order-1,
order-2, etc pages in the freelists.
