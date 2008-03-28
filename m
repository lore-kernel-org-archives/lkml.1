Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbYC1WCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbYC1WCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbYC1WCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:02:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953AbYC1WCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:02:18 -0400
Date: Fri, 28 Mar 2008 15:01:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Oops/Warning report for the week of March 28th 2008
In-Reply-To: <1206740581.22530.83.camel@johannes.berg>
Message-ID: <alpine.LFD.1.00.0803281500100.14670@woody.linux-foundation.org>
References: <47ED3F1A.1090101@linux.intel.com>  <alpine.LFD.1.00.0803281310480.14670@woody.linux-foundation.org>  <alpine.LFD.1.00.0803281329340.14670@woody.linux-foundation.org>  (sfid-20080328_205203_254278_BF9EB41F) <1206738071.22530.80.camel@johannes.berg>
  <alpine.LFD.1.00.0803281418570.14670@woody.linux-foundation.org> <1206740581.22530.83.camel@johannes.berg>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 Mar 2008, Johannes Berg wrote:
> 
> I tend to think it's actually a regression, I've done exactly what I
> described there dozens of times before on older kernels and it doesn't
> seem to be a race condition, X always locks the input device and I never
> had trouble with that before.

Ahh. So it's easily repeatable for you.. Do you think you could bisect it? 
At least a few runs? Even a partial bisection will give a nice (== much 
smaller) range of commits to be blamed, and might tell us why it started 
happening..

			Linus
