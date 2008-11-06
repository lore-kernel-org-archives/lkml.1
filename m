Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYKFKlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYKFKlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYKFKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:40:37 -0500
Received: from ozlabs.org ([203.10.76.45]:60813 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbYKFKkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:40:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18706.51153.342079.586525@cargo.ozlabs.ibm.com>
Date: Thu, 6 Nov 2008 21:32:49 +1100
From: Paul Mackerras <paulus@samba.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>, sparclinux@vger.kernel.org
Subject: Re: sparc/staging compile error
In-Reply-To: <20081106063709.GB7728@kroah.com>
References: <20081106163626.2306ad75.sfr@canb.auug.org.au>
	<20081106063709.GB7728@kroah.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH writes:

> On Thu, Nov 06, 2008 at 04:36:26PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > Today's tree from Linus gets the following error from a sparc
> > allmodconfig build:
> > 
> > ERROR: "___f_flush_cache_range" [drivers/staging/poch/poch.ko] undefined!
> 
> Odd, is flush_cache_range() not allowed on the sparc platform?

I'm curious, what is a driver doing calling flush_cache_range()?
What does it expect it to do precisely?

Paul.
