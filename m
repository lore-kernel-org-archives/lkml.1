Return-Path: <linux-kernel-owner+w=401wt.eu-S1759796AbZJMNFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796AbZJMNFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759762AbZJMNFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:05:16 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56553 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759750AbZJMNFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:05:15 -0400
Date: Tue, 13 Oct 2009 22:03:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Jie Zhang <jie.zhang@analog.com>, Robin Getz <rgetz@analog.com>
Subject: Re: [PATCH v2] NOMMU: fix malloc performance by adding uninitialized flag
Message-ID: <20091013130336.GA1245@linux-sh.org>
References: <32310.1255428618@redhat.com> <1255432821-1104-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255432821-1104-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 07:20:21AM -0400, Mike Frysinger wrote:
> From: Jie Zhang <jie.zhang@analog.com>
> 
> The NOMMU code currently clears all anonymous mmapped memory.  While this
> is what we want in the default case, all memory allocation from userspace
> under NOMMU has to go through this interface, including malloc() which is
> allowed to return uninitialized memory.  This can easily be a significant
> performance penalty.  So for constrained embedded systems were security is
> irrelevant, allow people to avoid clearing memory unnecessarily.
> 
> This also alters the ELF-FDPIC binfmt such that it obtains uninitialised
> memory for the brk and stack region.
> 
> Signed-off-by: Jie Zhang <jie.zhang@analog.com>
> Signed-off-by: Robin Getz <rgetz@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: Paul Mundt <lethal@linux-sh.org>
