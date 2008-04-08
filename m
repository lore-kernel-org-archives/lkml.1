Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbYDHAlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbYDHAlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 20:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYDHAlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 20:41:15 -0400
Received: from rn-out-0910.google.com ([64.233.170.189]:56700 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbYDHAlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 20:41:14 -0400
Subject: Re: fully bisectable real time series
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, mingo@elte.hu
In-Reply-To: <1207611243.21308.167.camel@localhost.localdomain>
References: <1207611243.21308.167.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 17:41:09 -0700
Message-Id: <1207615269.17662.9.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-07 at 16:34 -0700, Daniel Walker wrote:
> I've re-worked the -rt series, and some of the core patches to make it
> all bisectable. I've done bisect updates in the past which really only
> scratched the surface.

I had started on a forward-port to .25, but I got completely
side-tracked with a lot of other stuff.

The bi-sectable series is vary valuable for such porting efforts, and
the current series needs major cleanup, since there are a lot of fixes,
and code-backouts (e.g. softirq from hardirq thread context), which
interfere with testing of a back-port at each level.

So this is a valuable effort, and I hope that at least some of what you
have done will make it into .25's RT port.

If I have time to work on the port in the next couple of days, before
Steven gets to it, I will see what if any of your stuff can be used.

Thanks,

Sven

