Return-Path: <linux-kernel-owner+w=401wt.eu-S965069AbXCLEkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069AbXCLEkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 00:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965088AbXCLEkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 00:40:13 -0400
Received: from [212.12.190.145] ([212.12.190.145]:32804 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S965069AbXCLEkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 00:40:11 -0400
From: Al Boldi <a1426z@gawab.com>
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 12 Mar 2007 07:42:40 +0300
User-Agent: KMail/1.5
Cc: ck list <ck@vds.kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703120852.05857.kernel@kolivas.org> <200703120912.24156.kernel@kolivas.org>
In-Reply-To: <200703120912.24156.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703120742.41041.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Con Kolivas wrote:
> On Monday 12 March 2007 08:52, Con Kolivas wrote:
> > And thank you! I think I know what's going on now. I think each rotation
> > is followed by another rotation before the higher priority task is
> > getting a look in in schedule() to even get quota and add it to the
> > runqueue quota. I'll try a simple change to see if that helps. Patch
> > coming up shortly.
>
> Can you try the following patch and see if it helps. There's also one
> minor preemption logic fix in there that I'm planning on including.
> Thanks!

Applied on top of v0.28 mainline, and there is no difference.

What's it look like on your machine?


Thanks!

--
Al

