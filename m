Return-Path: <linux-kernel-owner+w=401wt.eu-S1751589AbXB0ONJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbXB0ONJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbXB0ONJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:13:09 -0500
Received: from [212.12.190.16] ([212.12.190.16]:32897 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751589AbXB0ONC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:13:02 -0500
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Tue, 27 Feb 2007 17:15:35 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200702271715.35309.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> Ingo Molnar (mingo@elte.hu) wrote:
> > based servers. The measurements so far have shown that the absolute
> > worst-case threading server performance is at around 60% of that of
> > non-context-switching servers - and even that level is reached
> > gradually, leaving time for action for the server owner. While with
> > fully event based servers there are mostly only two modes of
> > performance: 100% performance and near-0% performance: total breakdown.
>
> Let's live in piece! :)
> I always agreed that they should be used together - event-based rings
> of IO requests, if request happens to block (which should be avaided
> as much as possible), then it continues on behalf of sleeping thread.

Agreed 100%.  Notify always when you can, thread only when you must.


Thanks!

--
Al

