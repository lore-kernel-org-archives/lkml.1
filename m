Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZBRSFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZBRSFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 13:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZBRSFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 13:05:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751991AbZBRSFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:05:37 -0500
Date: Wed, 18 Feb 2009 10:04:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: david@lang.hm
Cc: Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       DL-MPTFusionLinux@lsi.com, linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: enable MSI on 8132
Message-Id: <20090218100448.7f7c5b86.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm>
References: <499B46B2.5040601@kernel.org>
	<alpine.DEB.1.10.0902171537260.26625@asgard.lang.hm>
	<499B6BF7.9090300@kernel.org>
	<alpine.DEB.1.10.0902171803040.26625@asgard.lang.hm>
	<499B724A.2040408@kernel.org>
	<alpine.DEB.1.10.0902171832560.26625@asgard.lang.hm>
	<alpine.DEB.1.10.0902171839420.26625@asgard.lang.hm>
	<499B774C.5010705@kernel.org>
	<alpine.DEB.1.10.0902171917420.26625@asgard.lang.hm>
	<499B9129.50104@kernel.org>
	<20090218122137.GJ16841@parisc-linux.org>
	<alpine.DEB.1.10.0902180426420.25606@asgard.lang.hm>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 04:27:28 -0800 (PST) david@lang.hm wrote:

> On Wed, 18 Feb 2009, Matthew Wilcox wrote:
> 
> > On Tue, Feb 17, 2009 at 08:40:09PM -0800, Yinghai Lu wrote:
> >>
> >> Impact: workaround BIOS that doesn't enable that bit
> >>
> >> David reported that LSI sas doesn't work with MSI.
> >> it turns out that BIOS doesn't enable HT MSI
> >> 8132 does support HT MSI.
> >> add quirk to enable it
> >>
> >> Reported-by: David Lang <david@lang.hm>
> >> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >
> > Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
> >
> > Jesse, I think this should go into Linus' tree sooner rather than later.
> 
> please forward to -stable as well. this is a regression since the card 
> works with older kernels.
> 

Which kernel version introduced the regression?

Do we not need mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch as
well, to fix this regression?

I sent mpt-fix-enable-lsi-sas-to-use-msi-as-default.patch to the
maintainers a week ago and it was ignored, along with everything else. 
If this happens again I shall merge it under my own cognisance, along
with everything else.

