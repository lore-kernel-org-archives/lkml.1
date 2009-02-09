Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZBINfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZBINfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbZBINfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:35:42 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:59490 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbZBINfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:35:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dAy3831hbyHnsqGSha9z2dU5ZIPmkxuA1CrxD5qbWgd4X6EUZHBWZ4l+f6KXUyqBRA
         8YmM2Qdp3/BF8+1gpY/ZQMwMcfbLkkygUmhZ8NQBGkC6IFvvYFLLESq18D7L36J8+OBp
         r2KxL9ZQglFRjmr4+T7CX9zmc/Tue7JdCfzIw=
Date: Mon, 9 Feb 2009 14:35:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: fix a build breakage on latest -tip
Message-ID: <20090209133534.GB4705@nowhere>
References: <20090208235838.GA4729@nowhere> <20090209090727.GD31890@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209090727.GD31890@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 10:07:27AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > A recent conflict resolve (c2eefa20c3ab45ab2108ce7e6561364ea92d7334)
> > did put twice the function suspend_test() on kernel/power/main.c
> > 
> > The version added for CONFIG_PM_TEST_SUSPEND to solve the conflict overlaps
> > the one changed recently on (091d71e023557136e96f0e54f301497a3fc95dc3)
> > since PM_TEST_SUSPEND depends on SUSPEND.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> This conflict existed for about 10 minutes until automation caught it :)
> Latest tip/master is fine, right?


Right!
Nobody's faster than -tip testing ;-)


> 	Ingo

