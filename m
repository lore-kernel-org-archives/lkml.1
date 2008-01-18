Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYAREnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYAREnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 23:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbYAREmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 23:42:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751566AbYAREmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 23:42:51 -0500
Date: Thu, 17 Jan 2008 20:42:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org, Zan Lynx <zlynx@acm.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
Message-Id: <20080117204247.5318e500.akpm@linux-foundation.org>
In-Reply-To: <200801180319.m0I3Ju9N089501@www262.sakura.ne.jp>
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp>
	<20080117181935.02294863.akpm@linux-foundation.org>
	<200801180319.m0I3Ju9N089501@www262.sakura.ne.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 12:19:56 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Hello.
> 
> Andrew Morton wrote:
> > I'd be suspecting git-sched, so in lieu of a full bisection search it would
> > be great if one of you could apply
> > http://userweb.kernel.org/~akpm/git-sched.patch to 2.6.24-rc8 and see if it
> > fails in the same way.
> Too bad. It didn't fail.
> 

I used your exact .config with the current mm lineup (I don't thinlk
anything relevant has changed) and it booted OK on my old PIII machine.

It could be compiler version dependent.  I used gcc-4.1.0.  Which version
were you and Zan using please?

