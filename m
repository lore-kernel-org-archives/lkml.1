Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbXKUD5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbXKUD5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 22:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbXKUD53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 22:57:29 -0500
Received: from outmail1.freedom2surf.net ([194.106.33.237]:42294 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbXKUD52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 22:57:28 -0500
Subject: Re: [patch] 0/4 Support for Toshiba TMIO multifunction devices
From: ian <spyro@f2s.com>
To: eric miao <eric.y.miao@gmail.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <f17812d70711201823w6201bf88uf6268aaee3a32312@mail.gmail.com>
References: <1195591234.2329.52.camel@wirenth> <474359E3.2020603@gmail.com>
	 <1195597252.2329.70.camel@wirenth>
	 <f17812d70711201823w6201bf88uf6268aaee3a32312@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Nov 2007 03:54:15 +0000
Message-Id: <1195617255.2329.78.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-21 at 10:23 +0800, eric miao wrote:
> Roughly went through the patch, looks good, here comes the remind, though :-)
> 
> 1. is it possible to use some name other than "soc_core", maybe
> "tmio_core" so that other multifunction chips sharing a core base
> will live easier.

It's (soc-core) not tmio MFD specific - its already used by other MFD
chips (although obviously not ones in mainline (yet!)

it might be better named 'mfd-core' though, as thats its intended use...

> 2. those C++ style comments "//" are not so pleasant...

Should I clean them up and resubmit?

More to the point, who should I be submitting them to? the files under
arm/ are obviously for RMK to peruse, but I couldnt find an entry for
drivers/mfd in MAINTAINERS...


