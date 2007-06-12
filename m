Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbXFLPjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbXFLPjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbXFLPjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:39:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:46983 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbXFLPjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:39:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,412,1175497200"; 
   d="scan'208";a="238267047"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Tue, 12 Jun 2007 08:39:07 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>
References: <200706061229.24486.jesse.barnes@intel.com> <200706071030.15317.jesse.barnes@intel.com> <m13b12rqel.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13b12rqel.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120839.08239.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 8, 2007 4:13:22 Eric W. Biederman wrote:
> Jesse Barnes <jesse.barnes@intel.com> writes:
> >> - Overlapping MTRRs.
> >
> > Overlapping should be ok, since that's usually intentional (e.g.
> > one big wb range with a portion of uc space due to another mtrr).
>
> I'm not say overlapping was a bug.  I was saying that you don't
> handle overlapping mtrrs in figuring the last cached addresses. 
> Therefore when a UC range overlaps a WB range we might thing the last
> page in the WB range is cached when it is not.

Oh right, that might be an issue, but we haven't seen it yet...

Jesse
