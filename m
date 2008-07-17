Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYGQH2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYGQH2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbYGQH1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:27:55 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:58314 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751867AbYGQH1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:27:55 -0400
Date: Thu, 17 Jul 2008 16:27:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: petkovbb@googlemail.com, jrigby@freescale.com,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Fix collateral damage to top level Makefile
Message-ID: <20080717072731.GB12273@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Grant Likely <grant.likely@secretlab.ca>, petkovbb@googlemail.com,
	jrigby@freescale.com, linux-kernel@vger.kernel.org,
	benh@kernel.crashing.org, torvalds@linux-foundation.org
References: <20080717070549.30755.13083.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717070549.30755.13083.stgit@trillian.secretlab.ca>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 01:06:55AM -0600, Grant Likely wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
> 
> The patch named "powerpc/mpc5121: Add clock driver", also contained
> an unrelated and bogus change to the top-level makefile.  This patch
> backs out the bad bit.
> 
> SHA1 of offending patch: 137e95906e294913fab02162e8a1948ade49acb5)
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> If the maintainer who picked up this patch (Grant Likely) had done
> his job, this cack-up never would have happened.  Why do we still
> have to deal with such sloppy individuals?
> 
I think the more important question is why the hell would anyone put that
in a Makefile, ever? ;-)
