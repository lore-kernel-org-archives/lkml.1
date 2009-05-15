Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbZEOFcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbZEOFcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbZEOFcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:32:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbZEOFcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:32:35 -0400
Subject: Re: 2.6.30-rc kills my box hard - and lockdep chains
From: Peter Zijlstra <peterz@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090514094951.36fd7333@bike.lwn.net>
References: <20090514094951.36fd7333@bike.lwn.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 15 May 2009 07:32:35 +0200
Message-Id: <1242365555.26820.51.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 09:49 -0600, Jonathan Corbet wrote:
> First time gave me:
> 
>         BUG: MAX_LOCKDEP_ENTRIES too low!
> 
> So I doubled it.  Now I get:
> 
> May 14 01:06:55 bike kernel: [38730.804833] BUG: MAX_LOCKDEP_CHAINS
> too low!

Ingo recently raised these numbers, from the -tip tree:

commit d80c19df5fcceb8c741e96f09f275c2da719efef
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue May 12 16:29:13 2009 +0200

    lockdep: increase MAX_LOCKDEP_ENTRIES and MAX_LOCKDEP_CHAINS


This will likely make its way upstream soonish.
