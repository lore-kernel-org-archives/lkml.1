Return-Path: <linux-kernel-owner+w=401wt.eu-S1764611AbXLTRdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764611AbXLTRdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 12:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXLTRdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 12:33:47 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:39951 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbXLTRdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 12:33:46 -0500
Date: Thu, 20 Dec 2007 17:21:44 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: balbir@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <haveblue@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Move page_assign_page_cgroup to VM_BUG_ON in free_hot_cold_page
In-Reply-To: <20071220091215.a87d2588.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712201715160.16967@blonde.wat.veritas.com>
References: <20071219061834.8461.3974.sendpatchset@balbir-laptop>
 <1198084473.15321.48.camel@localhost> <Pine.LNX.4.64.0712201312490.17015@blonde.wat.veritas.com>
 <1198158702.6821.8.camel@twins> <Pine.LNX.4.64.0712201411510.22773@blonde.wat.veritas.com>
 <1198160410.6821.13.camel@twins> <476A972F.6050904@linux.vnet.ibm.com>
 <20071220091215.a87d2588.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007, Andrew Morton wrote:
> On Thu, 20 Dec 2007 21:54:15 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > I was going to say the same thing, page_get_page_cgroup() does not hold
> > any references. May be _get_ in the name is confusing.
> 
> It is a bit unconventional.  page_cgroup()?

Seems ideal to me
(though there is some argument for page_page_cgroup(), weird as it is).

Hugh
