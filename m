Return-Path: <linux-kernel-owner+w=401wt.eu-S1760251AbZEKWrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760251AbZEKWrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760649AbZEKWrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:47:03 -0400
Received: from sh.osrg.net ([192.16.179.4]:51171 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760713AbZEKWrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:47:00 -0400
Date: Tue, 12 May 2009 07:45:43 +0900
To: jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, x86@kernel.org,
       linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [GIT PULL] xen: swiotlb support for Xen dom0
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A08597A.6090408@goop.org>
References: <1241741842-7966-1-git-send-email-jeremy@goop.org>
	<20090511123626N.fujita.tomonori@lab.ntt.co.jp>
	<4A08597A.6090408@goop.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090512074702W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 12 May 2009 07:45:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 09:59:38 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> FUJITA Tomonori wrote:
> > As I said before, I don't like such weak hacks added for dom0. We will
> > merge dom0 support?
> >   
> 
> That's in progress.  But they're largely the same hooks that ppc is 
> using as well.

As I explained before, if we have only ppc here, I can remove all the
hacks by using arch/include/asm cleanly. These hacks are just due to
dom0.
