Return-Path: <linux-kernel-owner+w=401wt.eu-S1751133AbXCLRjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbXCLRjd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 13:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXCLRjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 13:39:33 -0400
Received: from [212.12.190.186] ([212.12.190.186]:33049 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751133AbXCLRjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 13:39:32 -0400
From: Al Boldi <a1426z@gawab.com>
To: jos poortvliet <jos@mijnkamer.nl>, ck@vds.kolivas.org
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free interactive cpu scheduler
Date: Mon, 12 Mar 2007 20:41:37 +0300
User-Agent: KMail/1.5
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703121714.25034.a1426z@gawab.com> <200703121559.23157.jos@mijnkamer.nl>
In-Reply-To: <200703121559.23157.jos@mijnkamer.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703122041.37135.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jos poortvliet wrote:
> > It only takes one negatively nice'd proc to affect X adversely.
>
> Then, maybe, we should start nicing X again, like we did/had to do until a
> few years ago? Or should we just wait until X gets fixed (after all,
> development goes faster than ever)? Or is this really the scheduler's
> fault?

It's not enough to renice X.  You would have to renice it, and any app that 
needed fixed latency, to the same nice of the negatively nice'd proc, which 
defeats the purpose...


Thanks!

--
Al

