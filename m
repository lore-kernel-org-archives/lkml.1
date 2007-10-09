Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbXJIRQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbXJIRQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 13:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXJIRQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 13:16:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbXJIRQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 13:16:40 -0400
Date: Tue, 9 Oct 2007 13:16:38 -0400
From: Rik van Riel <riel@redhat.com>
To: "Mr. Berkley Shands" <bshands@exegy.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-rc9 kswapd infinite loop
Message-ID: <20071009131638.190989af@cuia.boston.redhat.com>
In-Reply-To: <470BAD2E.7000305@exegy.com>
References: <470BAD2E.7000305@exegy.com>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Oct 2007 11:32:46 -0500
"Mr. Berkley Shands" <bshands@exegy.com> wrote:

> I have a reproducible hang with kswapd in the run queue, everything else is
> in an i/o wait. The load average is climbing.

> Hints anyone (please) as to how to slay this dragon?

Since kswapd is running the whole time, sysrq-P could give a useful set of
backtraces (with a bit of luck).  With a handful of different backtraces
it should be obvious which functions kswapd is looping through.

Once we have that, I'll try to whip up a patch to get it fixed.

-- 
All Rights Reversed
