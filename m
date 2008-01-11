Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbYAKRb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbYAKRb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761203AbYAKRbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:31:48 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:12011 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760805AbYAKRbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:31:46 -0500
X-IronPort-AV: E=Sophos;i="4.24,272,1196668800"; 
   d="scan'208";a="19882451"
Date: Fri, 11 Jan 2008 09:29:15 -0800
From: Vince Fuller <vaf@cisco.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vince Fuller <vaf@cisco.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 001/001] ipv4: enable use of 240/4 address space
Message-ID: <20080111172915.GA6199@cisco.com>
References: <20080108011057.GA21168@cisco.com> <p73bq7smx1t.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73bq7smx1t.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Authentication-Results: sj-dkim-3; header.From=vaf@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 12:17:02PM +0100, Andi Kleen wrote:
> Vince Fuller <vaf@cisco.com> writes:
> 
> > from Vince Fuller <vaf@vaf.net>
> >
> > This set of diffs modify the 2.6.20 kernel to enable use of the 240/4
> > (aka "class-E") address space as consistent with the Internet Draft
> > draft-fuller-240space-00.txt.
> 
> Wouldn't it be wise to at least wait for it becoming an RFC first? 

There is reasonable consensus on making use of 240/4; some applications,
such as ISAKMP and automatic ipv6-to-IPv4 tunneling, still need to determine
if they should treat the space as "public" or "private" but that shouldn't
affect whether kernel support is added.

Solaris recently added support for 240/4 and OSX already has it. I thought
the Linux kernel developers might appreciate having patches to do likewise.

I leave it up to you, the developers, to decide if you want to use these
patches.

	--Vince
