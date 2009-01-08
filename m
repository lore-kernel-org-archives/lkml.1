Return-Path: <linux-kernel-owner+w=401wt.eu-S1763350AbZAHWqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763350AbZAHWqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756301AbZAHWqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:46:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbZAHWqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:46:34 -0500
Date: Thu, 8 Jan 2009 14:45:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] Kernel memory leak detector
Message-Id: <20090108144538.e5195575.akpm@linux-foundation.org>
In-Reply-To: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 18:12:56 +0000
Catalin Marinas <catalin.marinas@arm.com> wrote:

> A new kmemleak version is available.

Sorry, I'll drop this.  The level of code churn in linux-next (during
the merge window!) means that I've basically lost confidence that my
lameass fixed-up code will still even work.

What makes things worse here is that people tromp on other people's
code, or make changes without looking in linux-next to see what changes
other people have made.  This causes Stephen to give up and drop the
offending tree, so others who had code based on that offending tree end
up having a mess to deal with as well.  Then, 24 or 48 hours later that
tree comes back again so the mess comes back again.

Please find out from Rusty (I think it's that tree?) when he's finished
futzing with everything (module.c, percpu code, etc) and then respin
these patches?

> git://linux-arm.org/linux-2.6.git kmemleak

It might be better to add that to linux-next.  If we want to merge
kmemleak.

