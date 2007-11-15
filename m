Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbXKOEfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbXKOEfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 23:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbXKOEe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 23:34:59 -0500
Received: from paragon.brong.net ([74.52.187.94]:45269 "EHLO paragon.brong.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbXKOEe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 23:34:58 -0500
Date: Thu, 15 Nov 2007 15:07:08 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071115040708.GB15302@brong.net>
References: <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113.043207.44732743.davem@davemloft.net> <20071113110259.44c56d42.akpm@linux-foundation.org> <alpine.DEB.0.9999.0711132055550.7865@sheep.housecafe.de> <20071113130411.26ccae12.akpm@linux-foundation.org> <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99999.0711132239350.3960@sheep.housecafe.de>
Organization: brong.net
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 10:56:01PM +0100, Christian Kujau wrote:
> On Tue, 13 Nov 2007, Andrew Morton wrote:
>> There are a number of process things we _could_ do.  Like
>> - have bugfix-only kernel releases
>
> Adrian Bunk does (did?) this with 2.6.16.x, although it always seemed to me 
> like an unrewarded one man show. AFAIK not even the big distros are begging 
> for bugfix-only versions, as they too want to have (sell) new features. 
> Mission critical systems might want to require such versions, but I guess 
> they're using heavily customized trees anyway.

And congratulations to him for that.  We almost entirely dropped 2.6.16,
but there's a regression some time since then that makes large MMAPed
files a major pain (specifically the dcc database clean takes about 5
minutes on 2.6.16 and about 12 hours on 2.6.20 or 2.6.23 series kernels)

But we keep putting off writing a small testcase that can repeat the
issue so we can bisect it - because it's working fine with 2.6.16 on
that machine.

Bron.
