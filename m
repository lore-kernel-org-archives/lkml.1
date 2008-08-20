Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYHTMFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYHTMFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 08:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbYHTME6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 08:04:58 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1424 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbYHTME5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 08:04:57 -0400
Date: Wed, 20 Aug 2008 14:02:23 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: john stultz <johnstul@us.ibm.com>,
       Martin Ziegler <ziegler@uni-freiburg.de>,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] fix adjtimex() freq return error
In-Reply-To: <20080819204752.d9540f15.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0808201352190.2507@localhost.localdomain>
References: <1219199346.6276.5.camel@localhost> <20080819204752.d9540f15.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 19 Aug 2008, Andrew Morton wrote:

> On Tue, 19 Aug 2008 19:29:06 -0700 john stultz <johnstul@us.ibm.com> wrote:
> 
> > Martin Ziegler reported a bug in adjtimex(), where odd positive 
> > frequencies are reduced by 1 while negative values are correct.

To put this in perspective one should also know that 1 here means an error 
of 2^-16ppm or less than 0.02nsec.
When I wrote this code, I noticed that the rounding isn't perfect, but 
OTOH the error is so small that it can't have any practical relevance.
AFAIC the old code is fine as is.

bye, Roman
