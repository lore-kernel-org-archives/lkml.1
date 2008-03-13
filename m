Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYCMS7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYCMS7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 14:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYCMS64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 14:58:56 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:50310 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbYCMS6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 14:58:55 -0400
Date: Thu, 13 Mar 2008 18:55:38 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au, zach@vmware.com,
       frankeh@watson.ibm.com, rusty@rustcorp.com.au, andrea@qumranet.com,
       clameter@sgi.com, a.p.zijlstra@chello.nl,
       Keir Fraser <keir@xensource.com>, Ian Pratt <ian.pratt@xensource.com>
Subject: Re: [patch 0/6] Guest page hinting version 6.
In-Reply-To: <47D9754B.1030509@goop.org>
Message-ID: <Pine.LNX.4.64.0803131848080.800@blonde.site>
References: <20080312132132.520833247@de.ibm.com> <Pine.LNX.4.64.0803131627450.17244@blonde.site>
 <47D9754B.1030509@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Jeremy Fitzhardinge wrote:
> 
> My other concern is just correctness over time on the Linux side.  We already
> have enough trouble keeping things like the pte and page structure state in
> sync, with resulting rare data-loss bugs.  Adding another layer which only
> applies in specific environments raises the possibility for new bugs to be
> un-noticed for a long time.  How can we structure the VM changes to make sure
> that its robust in the face of maintenance?

Yes, that's the main concern, as whenever lots of subtlety is added.
I wonder if there's any chance of a CONFIG_DEBUG mode, which could be
run on anybody's x86 machine, without involving any virtualization, but
in which the PAGE_STATEs become essential to the correct working of the mm.

Hugh
