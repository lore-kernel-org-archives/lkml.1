Return-Path: <linux-kernel-owner+w=401wt.eu-S1759215AbYFEQCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759215AbYFEQCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 12:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYFEQB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 12:01:57 -0400
Received: from waste.org ([66.93.16.53]:47563 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbYFEQB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 12:01:56 -0400
Subject: Re: [PATCH 2/5] pagemap: Change kpagecount to return the map
	count, not the reference count, of a page.
From: Matt Mackall <mpm@selenic.com>
To: Thomas Tuttle <ttuttle@google.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ca0a85e0806050804s798bba46wcb29d2582120bfab@mail.gmail.com>
References: <4ca0a85e0806050804s798bba46wcb29d2582120bfab@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 11:01:07 -0500
Message-Id: <1212681667.3953.159.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 11:04 -0400, Thomas Tuttle wrote:
> When trying to use pagemap to calculate the "proportional set size"
> [1] of a process, I discovered that there were often references to
> pages that could not be discovered by kpagecount.  I changed
> kpagecount to return the number of times a page is mapped, rather than
> referenced, so kpagecount is more useful for determining how many
> processes are using a page.

I'm pretty sure this has been suggested before and I was just too
thick-skulled to get it. Yes, the reference count is less useful.

Acked-by: Matt Mackall <mpm@selenic.com>

ps: It's much prefered to send patches inline.

-- 
Mathematics is the supreme nostalgia of our time.

