Return-Path: <linux-kernel-owner+w=401wt.eu-S1761591AbZFKCWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591AbZFKCWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758956AbZFKCWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:22:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50790 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757913AbZFKCWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:22:39 -0400
Subject: Re: [PATCH] Convert sh to use arch_getoffset() infrastructure
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lethal@linux-sh.org, Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <1244686231.8085.37.camel@localhost.localdomain>
References: <1244686231.8085.37.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 19:22:24 -0700
Message-Id: <1244686944.8085.39.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-10 at 19:10 -0700, john stultz wrote:
> This patch converts sh to use GENERIC_TIME via the arch_getoffset()
> infrastructure, reducing the amount of arch specific code we need to
> maintain.
> 
> This patch got dropped last cycle due to the high flux rate of the sh
> arch at the time, so I wanted to resubmit it again.

Bah. Apparently this was only true for the -mm and -tip trees, and this
patch is already queued up for 2.6.31 in Paul Mundt's -sh git tree.

Sorry for not catching that sooner.

thanks
-john


