Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbZE0UhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbZE0UhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:37:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZE0UhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:37:02 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:43422 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbZE0UhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:37:00 -0400
Date: Wed, 27 May 2009 13:35:11 -0700
From: "Larry H." <research@subreption.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [1/16] HWPOISON: Add page flag for poisoned pages
Message-ID: <20090527203511.GA26530@oblivion.subreption.com>
References: <200905271012.668777061@firstfloor.org> <20090527201226.CCCBB1D028F@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527201226.CCCBB1D028F@basil.firstfloor.org>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:12 Wed 27 May     , Andi Kleen wrote:
> 
> Hardware poisoned pages need special handling in the VM and shouldn't be 
> touched again. This requires a new page flag. Define it here.
> 
> The page flags wars seem to be over, so it shouldn't be a problem
> to get a new one.

I gave a look to your patchset and this is yet another case in which the
only way to truly control the allocation/release behavior at low level
(without intrusive approaches) is to -indeed- use a page flag.

If this gets merged I would like to ask Andrew and Christopher to look
at my recent memory sanitization patches. It seems the opinion about
adding new page flags isn't the same for everyone here.

	Larry

