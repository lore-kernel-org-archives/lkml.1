Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbXCMMrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbXCMMrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXCMMrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:47:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:32947 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbXCMMrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:47:24 -0400
From: Andi Kleen <ak@suse.de>
To: Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] Fix vmi time header bug
Date: Tue, 13 Mar 2007 13:45:06 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
References: <45F5DB00.1070506@vmware.com> <20070312223136.dc6969f3.akpm@linux-foundation.org> <45F648B1.5000408@vmware.com>
In-Reply-To: <45F648B1.5000408@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703131345.06514.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007 07:46, Zachary Amsden wrote:
> Andrew Morton wrote:
> > Really truly?   I think we have a _lot_ of declarations which omit the
> > section qualifier altogether.  How come they don't all break too?
>
> User build was smoking this:
>
> make O=build -j16
>
> This and non-repeatable results make me suspect some kind of build
> dependency problem, or perhaps a make bug.  Still, please apply, as it
> doesn't hurt.

I don't think the patch should make any difference, so that's not needed.

-Andi
