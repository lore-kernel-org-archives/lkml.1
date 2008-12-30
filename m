Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbYL3AXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbYL3AXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 19:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbYL3AXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 19:23:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbYL3AXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 19:23:20 -0500
Date: Mon, 29 Dec 2008 16:23:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 00/14] Kernel memory leak detector
Message-Id: <20081229162310.705a25fe.akpm@linux-foundation.org>
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

> A new kmemleak version is available. Thanks to all who reviewed the code
> and provided feedback.

There are a largeish number of trivialish rejects against all the
pending 2.6.29 code.  Fairly easily fixed.

I merge these patches into my tree, but I'd like to drop them again ;)

> Kmemleak can also be found on this git tree:
> 
> git://linux-arm.org/linux-2.6.git kmemleak

Please prepare and maintain a tree for inclusion in linux-next shortly
after 2.6.29-rc1 is released.




What is the track record of this code?  Has it found many leaks?  Do
we expect that it will find sufficient leaks of sufficient importance
to justify kmemleak's inclusion and maintenance?


I'm a little doubtful personally.  We often fix leaks, and they are
almost always things which nobody noticed at runtime, and which were
found by code inspection or source-code checking tools.  And they're
usually leaks which nobody would care about much anyway?

