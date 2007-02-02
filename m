Return-Path: <linux-kernel-owner+w=401wt.eu-S1945927AbXBBPLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945927AbXBBPLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 10:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945928AbXBBPLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 10:11:12 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:57312 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945927AbXBBPLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 10:11:12 -0500
Date: Fri, 2 Feb 2007 10:11:10 -0500
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       takada <takada@mbf.nifty.com>, Jordan Crouse <jordan.crouse@amd.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Please revert "fix typo in geode_configre()@cyrix.c"
Message-ID: <20070202151110.GM7582@csclub.uwaterloo.ca>
References: <20070202062941.GB3754@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202062941.GB3754@stusta.de>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 07:29:41AM +0100, Adrian Bunk wrote:
> Linus, please revert commit e4f0ae0ea63caceff37a13f281a72652b7ea71ba
> 
> Rationale:
> 
> The thread starting with http://lkml.org/lkml/2007/1/9/63 contains 
> a discussion about what might be a correct patch.
> 
> Somehow the first patch of this discussion made it into 2.6.20-rc, but 
> the ones considered more correct are later in the thread.
> 
> Since there is AFAIK no actually observed problem fixed by this, it 
> should be safe to simply revert the patch for 2.6.20.

True, the bits that are not being enabled are all performance related.
Getting the correct patch it should theoretically make systems with this
cpu series run faster.

--
Len Sorensen
