Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbXHTRXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbXHTRXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXHTRXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:23:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:33026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbXHTRXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:23:04 -0400
Date: Mon, 20 Aug 2007 20:16:57 +0200
From: Andi Kleen <ak@suse.de>
To: Roland Dreier <rdreier@cisco.com>
Cc: Arjan van de Ven <arjan@infradead.org>, discuss@x86-64.org, jh@suse.cz,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [discuss] [PATCH] x86-64: memset optimization
Message-ID: <20070820181657.GO16680@bingen.suse.de>
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net> <200708182055.11277.ak@suse.de> <20070819010430.2c8c31fc@oldman.hemminger.net> <200708192024.24864.ak@suse.de> <20070820085253.5f589e58@freepuppy.rosehill.hemminger.net> <1187625068.2577.3.camel@laptopd505.fenrus.org> <adamywmw32l.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adamywmw32l.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> so the code gets bigger and worse in every way.

I guess it would make sense to file this as a bug in the gcc
bugzilla

Another useful enhancement might be to have a -finline-string-functions
or similar that could be set with -Os. In general I've been wondering
for some time if the kernel really doesn't need some new optimization
setting somewhere between -Os and -O2. -Os occasionally has a few other 
bad side effects too.

-Andi
