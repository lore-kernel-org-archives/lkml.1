Return-Path: <linux-kernel-owner+w=401wt.eu-S934118AbXCFNgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118AbXCFNgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934115AbXCFNgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:36:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44890 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280AbXCFNgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:36:10 -0500
Date: Tue, 6 Mar 2007 14:36:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: shemminger@linux-foundation.org, andi@firstfloor.org,
       jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support
Message-ID: <20070306133608.GB864@one.firstfloor.org>
References: <20070226143127.5c74bec9@freekitty> <p73slcnawh3.fsf@bingen.suse.de> <20070305155714.3abe1b5e@freekitty> <20070305.162551.41660347.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305.162551.41660347.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 04:25:51PM -0800, David Miller wrote:
> Another thing is that the non-Hacker's Delight version iterates
> differently for different input values, so the input value space is
> very important to consider when comparing these two pieces of code.

I did some stochastic testing on my version. It gave 1 off for < 1% of
the arguments.  Probably not an issue.

Besides it actually works for >2^43 @)

-Andi
