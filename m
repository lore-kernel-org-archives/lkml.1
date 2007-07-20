Return-Path: <linux-kernel-owner+w=401wt.eu-S1763618AbXGTQ4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763618AbXGTQ4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S941425AbXGTQtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:49:23 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56416 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539AbXGTQtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:49:20 -0400
Message-ID: <46A0E76B.5050606@s5r6.in-berlin.de>
Date: Fri, 20 Jul 2007 18:48:43 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Satyam Sharma <satyam.sharma@gmail.com>,
       "clameter@sgi.com" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
References: <20070531002047.702473071@sgi.com>	 <20070531003012.302019683@sgi.com>	 <a781481a0707200341o21381742rdb15e6a9dc770d27@mail.gmail.com>	 <46A097FE.3000701@redhat.com>	 <a781481a0707200427y7a29257fpfa5978c391eb3534@mail.gmail.com>	 <46A09DB2.5040408@redhat.com> <a781481a0707200440v48dcf70fv621aec863562880c@mail.gmail.com> <46A0A186.4030908@redhat.com>
In-Reply-To: <46A0A186.4030908@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> There are many different ways you can use it.  If I'm writing a configurable 
> feature, I could make it depend on !CONFIG_STABLE, or I could ifdef my code out 
> if CONFIG_STABLE is set, unless a more granular option is also set.  The 
> maintainer of the code that uses the config option has a lot of flexibility,

In other words, nobody will ever know what this config option really does.

> at least until we start enforcing standards.
-- 
Stefan Richter
-=====-=-=== -=== =-=--
http://arcgraph.de/sr/
