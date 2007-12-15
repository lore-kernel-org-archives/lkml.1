Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbXLOGX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbXLOGX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 01:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXLOGXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 01:23:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:43791 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbXLOGXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 01:23:21 -0500
Subject: Re: [PATCH] Make WARN_ON/WARN_ON_ONCE no-ops when CONFIG_BUG is off
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20071214180246.GT17536@waste.org>
References: <20071214132755.GA18309@gondor.apana.org.au>
	 <20071214180246.GT17536@waste.org>
Content-Type: text/plain
Date: Sat, 15 Dec 2007 17:22:50 +1100
Message-Id: <1197699770.6696.50.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-14 at 12:02 -0600, Matt Mackall wrote:
> 
> I added CONFIG_BUG, and I think the current behavior is correct. As
> you've noticed, we have to evaluate condition, it may have
> side-effects. And if code does:
> 
>         /* this indicates a driver bug, report and fail gracefully */
>         if (WARN_ON(val == NULL))
>                 return -EFAULT;
> 
> ..we surely want it to continue returning -EFAULT, regardless of
> whether we log it, no? What use case did you have in mind?

I find such code totally distateful.

Ben.

