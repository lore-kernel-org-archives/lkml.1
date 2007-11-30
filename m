Return-Path: <linux-kernel-owner+w=401wt.eu-S934587AbXK3LiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934587AbXK3LiG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:38:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759716AbXK3Lhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:37:54 -0500
Received: from z2.cat.iki.fi ([212.16.98.133]:58338 "EHLO z2.cat.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756213AbXK3Lhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:37:54 -0500
Date: Fri, 30 Nov 2007 13:37:50 +0200
From: Matti Aarnio <matti.aarnio@zmailer.org>
To: Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071130113750.GD6372@mea-ext.zmailer.org>
References: <474EAD18.6040408@stellatravel.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474EAD18.6040408@stellatravel.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 12:14:16PM +0000, Ben Crowhurst wrote:
> Has Objective-C ever been considered for kernel development?
>
> regards,
> BPC

To my recall:  Never.

Some limited subset of C++ was tried, but was soon abandoned.

Overall the kernel data structures are done in objectish-manner,
although there are no strong type mechanisms being used.

Could the kernel be written in a limited subset[*] of ObjC ?  Very likely.
Would it be worth the job ?   Radical decrease in number of available
programmers...

*) Subset as enforcing the rule of not even indirectly using dynamic
   memory allocation, when operating in interrupt state.

      /Matti Aarnio
