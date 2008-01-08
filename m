Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYAHAKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYAHAKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 19:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYAHAKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 19:10:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187AbYAHAKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 19:10:08 -0500
Date: Mon, 7 Jan 2008 16:09:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: david@fries.net, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] system timer: fix crash in <100Hz system timer
Message-Id: <20080107160951.5b63d5dc.akpm@linux-foundation.org>
In-Reply-To: <4782BAED.7060102@zytor.com>
References: <20080105221653.GA10065@spacedout.fries.net>
	<20080107153650.0cb85eeb.akpm@linux-foundation.org>
	<4782BAED.7060102@zytor.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jan 2008 15:51:09 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> >> +		do_div(x, HZ / USER_HZ);
> >> +	#endif
> >>  #else
> >>  	/*
> >>  	 * There are better ways that don't overflow early,
> > 
> > Alas, I get 100% rejects due to conflicting changes from Peter's
> > avoid-overflows-in-kernel-timec.patch.
> > 
> > Peter, did that patch propagate this failure, or might it have happily
> > fixed it?
> > 
> 
> My patch doesn't touch any of these functions, nor touches any code 
> within 70 lines of this patch -- the last line touched is line 478 -- 
> and doesn't touch linux/acct.h at all, so how could it cause a conflict?

oop, sorry, it was the mime-mess-mangles-everything problem and I failed to
spot it.

> But no, it doesn't fix this particular problem, even if using a similar 
> technique might very well be a better way to do this kind of conversion.

OK.
