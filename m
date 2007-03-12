Return-Path: <linux-kernel-owner+w=401wt.eu-S965459AbXCLJ7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965459AbXCLJ7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965472AbXCLJ7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:59:42 -0400
Received: from smtp24.orange.fr ([193.252.22.26]:23559 "EHLO smtp24.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965452AbXCLJ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:59:18 -0400
X-Greylist: delayed 1226 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 05:59:18 EDT
X-ME-UUID: 20070312093850257.3ED871C000A0@mwinf2423.orange.fr
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Xavier Bestel <xavier.bestel@free.fr>
To: Con Kolivas <kernel@kolivas.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703122022.43021.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703121929.39702.kernel@kolivas.org>
	 <1173689733.6748.18.camel@Homer.simpson.net>
	 <200703122022.43021.kernel@kolivas.org>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 10:38:39 +0100
Message-Id: <1173692319.5835.611.camel@frg-rhel40-em64t-03>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 20:22 +1100, Con Kolivas wrote:
> On Monday 12 March 2007 19:55, Mike Galbraith wrote:
> > Hmm.  So... anything that's client/server is going to suffer horribly
> > unless niced tasks are niced all the way down to 19?
> 
> Fortunately most client server models dont usually have mutually exclusive cpu 
> use like this X case. There are many things about X that are still a little 
> (/me tries to think of a relatively neutral term)... wanting. :(

I'd say the problem is less with X than with Xlib, which is heavily
round-trip-based. Fortunately XCB (its successor) seeks to be more
asynchronous.

	Xav


