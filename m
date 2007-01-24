Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbXAXQ5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbXAXQ5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 11:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbXAXQ5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 11:57:10 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:57031 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752021AbXAXQ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 11:57:09 -0500
Date: Wed, 24 Jan 2007 11:57:09 -0500
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       takada <takada@mbf.nifty.com>, Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: 2.6.20-rc5: known unfixed regressions (v3) (part 2)
Message-ID: <20070124165708.GF7582@csclub.uwaterloo.ca>
References: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org> <20070124154725.GK17836@stusta.de> <20070124160631.GE7582@csclub.uwaterloo.ca> <20070124163801.GM17836@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070124163801.GM17836@stusta.de>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 05:38:01PM +0100, Adrian Bunk wrote:
> Was the removed
>   setCx86(CX86_CCR3, ccr3);
> without any effects?

I didn't think that was ever checked in.  I thought the patch was still
being discussed.

The line missing will not as far as I can see cause any problems, it
will leave some registers accessible that normaly are not, but unless
something was to try and access them that shouldn't matter.  It is of
course more correct to reprotect them after the required changes are
done so it should be put back (if it was ever actually removed).

--
Len Sorensen
