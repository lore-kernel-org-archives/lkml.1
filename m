Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZALJv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZALJv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZALJvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:51:18 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:49046 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbZALJvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:51:17 -0500
Subject: Re: [PATCH 00/14] Kernel memory leak detector
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090108144538.e5195575.akpm@linux-foundation.org>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	 <20090108144538.e5195575.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 12 Jan 2009 09:51:06 +0000
Message-Id: <1231753866.10982.11.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2009 09:51:07.0250 (UTC) FILETIME=[4A535D20:01C9749B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Thu, 2009-01-08 at 14:45 -0800, Andrew Morton wrote:
> On Fri, 19 Dec 2008 18:12:56 +0000
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > A new kmemleak version is available.
> 
> Sorry, I'll drop this.  The level of code churn in linux-next (during
> the merge window!) means that I've basically lost confidence that my
> lameass fixed-up code will still even work.

OK. I noticed some minor conflicts with 2.6.29-rc1 but I'll have a look
at linux-next as well. IIRC, is the -mm tree based on top of linux-next?

> > git://linux-arm.org/linux-2.6.git kmemleak
> 
> It might be better to add that to linux-next.  If we want to merge
> kmemleak.

I would feel a bit more comfortable if kmemleak lived for (at least) a
release cycle in the -mm tree so that it may get wider testing. As I
said, I mainly tested it on ARM.

If you are OK with this, I'll update the branch and make sure there are
as few conflicts as possible (the alternative is patches by e-mail and
based on top of linux-next).

-- 
Catalin

