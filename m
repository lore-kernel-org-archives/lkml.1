Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZCDX4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZCDX4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 18:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZCDX4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 18:56:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbZCDX4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 18:56:24 -0500
Date: Wed, 4 Mar 2009 15:55:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyungmin Park <kmpark@infradead.org>
Cc: adrian.hunter@nokia.com, h.rohit@samsung.com,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [MTD] Flex-OneNAND support
Message-Id: <20090304155544.3bc3f337.akpm@linux-foundation.org>
In-Reply-To: <9c9fda240903041547x540899f9hd94cbf49baac660b@mail.gmail.com>
References: <20090303063605.GA30258@july>
	<20090303124948.dda294e5.akpm@linux-foundation.org>
	<49AE6907.1080702@nokia.com>
	<20090304085055.c9de6cbb.akpm@linux-foundation.org>
	<9c9fda240903041547x540899f9hd94cbf49baac660b@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009 08:47:03 +0900
Kyungmin Park <kmpark@infradead.org> wrote:

> I think we know the issues currently and then if the device is opened,
> handle this one if required.
> How do you think?

I think it would be prudent to fix the known problems now, rather
than having to go through and re-debug them later on.

Bear in mind that people frequently copy old code when writing
new code, so these things tend to propagate, creating more work
later on.
