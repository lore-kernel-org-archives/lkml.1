Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYGWB2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYGWB2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 21:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYGWB2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 21:28:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYGWB2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 21:28:32 -0400
Date: Tue, 22 Jul 2008 21:26:11 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: penberg@cs.helsinki.fi, cl@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, rdunlap@xenotime.net, mpm@selenic.com
Subject: Re: [RFC PATCH 1/4] kmemtrace: Core implementation.
Message-ID: <20080723012611.GB28486@redhat.com>
References: <1216751493-13785-1-git-send-email-eduard.munteanu@linux360.ro> <1216751493-13785-2-git-send-email-eduard.munteanu@linux360.ro> <y0mvdyx7gnj.fsf@ton.toronto.redhat.com> <20080723005002.GA5206@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723005002.GA5206@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -


On Wed, Jul 23, 2008 at 03:50:02AM +0300, Eduard - Gabriel Munteanu wrote:

> [...]  Sounds like a good idea, but I'd like to get rid of markers
> and use Mathieu Desnoyers' tracepoints instead. I'm just waiting for
> tracepoints to get closer to inclusion in mainline/-mm.

OK.

> It would be great if tracepoints completely replaced markers, so
> SystemTap would use those instead.

Raw tracepoints are problematic as they require a per-tracepoint C
function signature to be synthesized by the tool (or hard-coded in the
tool or elsewhere).  We haven't worked out how best do to this.  OTOH,
markers don't require such hard-coding, so are simpler for a general
tool to interface to.


> However, if tracepoints are not ready when kmemtrace is to be merged,
> I'll take your advice and mention markers and SystemTap.

Thanks either way - I'm glad you found an existing tracing mechanism
usable and didn't choose/need to invent your own.


- FChE
