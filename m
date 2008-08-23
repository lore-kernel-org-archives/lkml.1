Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYHWTjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYHWTjR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 15:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYHWTim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 15:38:42 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:30842 "EHLO
	stargate.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753266AbYHWTik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 15:38:40 -0400
From: Divy Le Ray <divy@chelsio.com>
Organization: Chelsio Communications
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4 2.6.28] cxgb3i - cxgb3i iscsi driver
Date: Sat, 23 Aug 2008 12:31:38 -0700
User-Agent: KMail/1.9.9
Cc: "Karen Xie" <kxie@chelsio.com>, netdev@vger.kernel.org,
       open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com, davem@davemloft.net,
       michaelc@cs.wisc.edu, "Steve Wise" <swise@opengridcomputing.com>,
       rdreier@cisco.com, daisyc@us.ibm.com, wenxiong@us.ibm.com,
       bhua@us.ibm.com, "Dimitrios Michailidis" <dm@chelsio.com>,
       "Casey Leedom" <leedom@chelsio.com>
References: <200808221840.m7MIeuvB004442@localhost.localdomain> <20080822124844.b05ee3e8.akpm@linux-foundation.org>
In-Reply-To: <20080822124844.b05ee3e8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808231231.40751.divy@chelsio.com>
X-OriginalArrivalTime: 23 Aug 2008 19:31:14.0781 (UTC) FILETIME=[CE9298D0:01C90556]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008 12:48:44 pm Andrew Morton wrote:
> On Fri, 22 Aug 2008 11:40:56 -0700
>
> Karen Xie <kxie@chelsio.com> wrote:
> > [PATCH 4/4 2.6.28] cxgb3i - cxgb3i iscsi driver
> >
> > From: Karen Xie <kxie@chelsio.com>
> >
> > cxgb3i iSCSI driver.
> >
> > Signed-off-by: Karen Xie <kxie@chelsio.com>
>
> I'm going to suggest that this not be merged in this form due to the
> __GFP_NOFAIL issues identified below.
>

Hi Andrew,

thanks for the review. We've started fixing the obvious and looking at 
alternatives for the nofail allocations.

Cheers,
Divy
