Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYCKSc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYCKSc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 14:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755290AbYCKSb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 14:31:59 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:47490 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbYCKSb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 14:31:58 -0400
Date: Tue, 11 Mar 2008 21:36:06 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: document CLD_CONTINUED notification mechanics
Message-ID: <20080311183606.GE586@tv-sign.ru>
References: <20080309215338.GA2296@tv-sign.ru> <20080311021741.A863826F991@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080311021741.A863826F991@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(surprisingly, this is rather important issue for me ;)

On 03/10, Roland McGrath wrote:
>
> >  		if (why) {
> > +			/* The first thread which returns from finish_stop()
> 
> Canonical style is:
> 
> 			/*
> 			 * The first thread that returns from finish_stop()

Yes, I know. But the latter needs an extra line! Don't get me wrong, I am
not worrying about the result of `wc ...`, and I often add the blank lines
to improve the readability. But since the comment block itself adds the
"space", why should we lessen the number of the code lines visible to the
reader?

Oleg.

