Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZIXUvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZIXUvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 16:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZIXUvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 16:51:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37641 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZIXUvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:51:36 -0400
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20090924204357.GB8662@nowhere>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
	 <20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu>
	 <1253824200.18939.173.camel@laptop>  <20090924204357.GB8662@nowhere>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 22:51:29 +0200
Message-Id: <1253825489.18939.180.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 22:44 +0200, Frederic Weisbecker wrote:

> I don't quite understand why.
> 
> Typing file == "*reiserfs*" looks more intuitive.
> 
> It's true that the filters should stay tight to the C syntax,
> but following this guideline up to the point that we are forced to
> use function expressions to do something that can be expressed
> much more easily and more intuitively (IMHO), that all sounds like
> an overkill.
> 
> The use of glob is a very primary need for filters, it's
> so much a basic requirement for it that it should be native
> in its language.

The thing that my fingers know is awk syntax:

 file ~ /reiserfs/

I'd very much prefer to keep == for strict equality, however the above
requires actual regex bits.

Remember, there are no second chances for the filter syntax anymore.

