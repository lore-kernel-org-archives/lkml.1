Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbZJMPV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbZJMPV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755752AbZJMPV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:21:28 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:20979 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbZJMPV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:21:27 -0400
X-IronPort-AV: E=Sophos;i="4.44,551,1249272000"; 
   d="scan'208";a="5747404"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier@gentoo.org>
Subject: Re: [uClinux-dev] [PATCH] NOMMU: fix malloc performance by addinguninitialized flag
Date: Tue, 13 Oct 2009 11:20:59 -0400
User-Agent: KMail/1.9.5
CC: uclinux-dev@uclinux.org, "David Howells" <dhowells@redhat.com>,
       "David McCullough" <davidm@snapgear.com>,
       "Greg Ungerer" <gerg@uclinux.org>, "Paul Mundt" <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       "Zhang, Jie" <jie.zhang@analog.com>
References: <12871.1175267477@redhat.com> <1255419845-30504-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1255419845-30504-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200910131121.00343.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 13 Oct 2009 15:20:49.0705 (UTC) FILETIME=[BEC5F190:01CA4C18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13 Oct 2009 03:44, Mike Frysinger pondered:
> From: Jie Zhang <jie.zhang@analog.com>
> 
> The no-mmu code currently clears all anonymous mmap-ed memory.  While this
> is what we want in the default case, all memory allocation from userspace
> under no-mmu has to go through this interface, including malloc() which is
> allowed to return uninitialized memory.  This can easily be a significant
> performance slow down.  So for constrained embedded systems were security
> is irrelevant, allow people to avoid unnecessarily clearing memory.
> 
> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Robin Getz <rgetz@analog.com>

Should be rgetz@blackfin.uclinux.org -- rgetz@analog.com does not exist and will bounce.

