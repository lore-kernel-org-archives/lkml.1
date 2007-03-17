Return-Path: <linux-kernel-owner+w=401wt.eu-S1751123AbXCQG0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751123AbXCQG0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 02:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbXCQG0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 02:26:12 -0400
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:53390 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXCQG0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 02:26:11 -0400
Subject: Re: RSDL v0.31
From: Nicholas Miell <nmiell@comcast.net>
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>, ck@vds.kolivas.org,
       Ingo Molnar <mingo@elte.hu>, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1174110965.7911.44.camel@Homer.simpson.net>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703170040.48316.kernel@kolivas.org>
	 <1174059299.7886.25.camel@Homer.simpson.net>
	 <200703170813.32594.kernel@kolivas.org>
	 <1174084207.7009.9.camel@Homer.simpson.net>
	 <1174105443.3144.4.camel@entropy>
	 <1174110965.7911.44.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Fri, 16 Mar 2007 23:26:08 -0700
Message-Id: <1174112768.3144.8.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-17 at 06:56 +0100, Mike Galbraith wrote:
> On Fri, 2007-03-16 at 21:24 -0700, Nicholas Miell wrote:
> 
> > Sorry, I haven't really been following this thread and now I'm confused.
> > 
> > You're saying that it's somehow the scheduler's fault that X isn't
> > running with a high enough priority?
> 
> I'm saying that the current scheduler adjusts for interactive loads,
> this new one doesn't.  I'm seeing interactivity regressions, and they
> are not fixed with nice unless nice is used to maximum effect.  I'm
> saying yes, I can lower my expectations, but no I don't want to.
> 
> A four line summary is as short as I can make it.
> 
> 	-Mike

Uh, no. Essentially, the current scheduler works around X's brokenness,
in an often unpredictable manner.

RSDL appears to be completely deterministic, which is a very strong
virtue.

The X people have plans for how to go about fixing this, but until then,
there's no reason to hold up kernel development.

-- 
Nicholas Miell <nmiell@comcast.net>

