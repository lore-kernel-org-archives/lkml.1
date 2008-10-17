Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbYJQDNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbYJQDNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 23:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYJQDNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 23:13:12 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:38987 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYJQDNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 23:13:11 -0400
X-IronPort-AV: E=Sophos;i="4.33,428,1220227200"; 
   d="scan'208";a="176963609"
From: Roland Dreier <rdreier@cisco.com>
To: benh@kernel.crashing.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
References: <48F409E9.3030501@zytor.com>
	<20081013.223811.174710738.davem@davemloft.net>
	<Pine.LNX.4.64.0810161030120.9022@vixen.sonytel.be>
	<20081016.013850.85183428.davem@davemloft.net>
	<1224212533.7654.60.camel@pasglop> <1224212791.7654.63.camel@pasglop>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 16 Oct 2008 20:13:09 -0700
In-Reply-To: <1224212791.7654.63.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Fri, 17 Oct 2008 14:06:31 +1100")
Message-ID: <adatzbbap8a.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Oct 2008 03:13:10.0012 (UTC) FILETIME=[4871BBC0:01C93006]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > + * Right now we handle:
 > + *
 > + * - 'F' For symbolic Function descriptor pointers
 > + * - 'S' For Symbolic direct pointers), but this can easily be
 > + *       extended in the future (network address types etc).
 > + * - 'R' For a struct resouce pointer, it prints the range of
 > + *       addresses (not the name nor the flags)

A little too much cut and paste -- the "easily be extended" bit at 'S'
doesn't really make sense in the middle of the list.

 > + * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
 > + * function pointers are really function descriptors, which contain a
 > + * pointer the real address.

you cut and pasted Linus's typo too -- "a pointer the real address"
should probably be "a pointer *TO* the real address"

 - R.
