Return-Path: <linux-kernel-owner+w=401wt.eu-S933038AbZJFTqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbZJFTqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932457AbZJFTqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:46:38 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:62694 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932254AbZJFTqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:46:37 -0400
From: Frans Pop <elendil@planet.nl>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [patch] kbuild: Improve version string logic
Date: Tue, 6 Oct 2009 21:45:58 +0200
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, torvalds@linux-foundation.org, hohndel@infradead.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006173508.GA4786@elte.hu> <20091006173508.GA4786@elte.hu> <1254854227.22426.37.camel@johannes.local>
In-reply-To: <1254854227.22426.37.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910062146.00298.elendil@planet.nl>
X-OriginalArrivalTime: 06 Oct 2009 19:46:00.0667 (UTC) FILETIME=[A18DD2B0:01CA46BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
> I think adding the + unconditionally will also break things like
> debian's make-kpkg, for instance, since the + would get propagated into
> the package version which reserves the + for something else.

Are you sure? AFAIK it would be propagated into the package _name_, where 
it is allowed. And even if it were part of the package version, it would 
be in the "upstream" part of the version number, where it is also allowed.

The only reserved use of "+" I'm aware of is in the Debian part of the 
package version.

But I have not used make-kpkg in ages, so I'm not 100% sure how that builds 
the package version. I could be that it duplicates the kernel version in 
both the package name and the upstream part of the package version, but 
that should still be OK.

Cheers,
FJP
