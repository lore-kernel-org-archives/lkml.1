Return-Path: <linux-kernel-owner+w=401wt.eu-S1762547AbXFARpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762547AbXFARpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760309AbXFARpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:45:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49912 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbXFARpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:45:13 -0400
Date: Fri, 1 Jun 2007 19:45:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] Conditional Calls - Hash Table
Message-ID: <20070601174510.GG7217@one.firstfloor.org>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.398040643@polymtl.ca> <p731wgxds85.fsf@bingen.suse.de> <20070601160802.GL11166@waste.org> <20070601164623.GB4112@Krystal> <20070601170739.GA11115@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601170739.GA11115@waste.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It's not clear to me why either of those things are necessary. An
> example please?

It's certainly possible that a global flag would need to be tested
more than once.

I guess it would work if a symbol is associated with a single
definition. e.g. if there is a DEFINE_COND_CALL() somewhere
and the individual cond calls reference it.

-Andi
