Return-Path: <linux-kernel-owner+w=401wt.eu-S1031211AbXDQU6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031211AbXDQU6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 16:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031224AbXDQU6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 16:58:38 -0400
Received: from waste.org ([66.93.16.53]:55243 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031211AbXDQU6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 16:58:38 -0400
Date: Tue, 17 Apr 2007 15:45:57 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/13] maps#2: Move the page walker code to lib/
Message-ID: <20070417204557.GL11115@waste.org>
References: <7.469046093@selenic.com> <461C81C0.9040003@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461C81C0.9040003@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 04:35:44PM +1000, Nick Piggin wrote:
> Matt Mackall wrote:
> >Move the page walker code to lib/
> >
> >This lets it get shared outside of proc/ and linked in only when
> >needed.
> 
> Still should go into mm/
> 
> If it had, you might have also noticed your pagetable walking code
> is completely different from how everyone else does it, and fixed
> that too.

I'll try to fix this up next week.

-- 
Mathematics is the supreme nostalgia of our time.
