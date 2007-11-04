Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXKDSbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXKDSbQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 13:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbXKDSbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 13:31:05 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:33567 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbXKDSbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 13:31:04 -0500
Date: Sun, 4 Nov 2007 18:29:54 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Michael Marineau <mike@marineau.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH, RESEND] tmpfs: fix mounts when size is less than the
 page size
In-Reply-To: <c0526ddf0711041012x7b41269x12a05ddb6e03a04d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711041823460.14211@blonde.wat.veritas.com>
References: <11941279021705-git-send-email-mike@marineau.org> 
 <11941336124117-git-send-email-mike@marineau.org> 
 <Pine.LNX.4.64.0711041202260.4631@blonde.wat.veritas.com>
 <c0526ddf0711041012x7b41269x12a05ddb6e03a04d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Nov 2007, Michael Marineau wrote:
> On 11/4/07, Hugh Dickins <hugh@veritas.com> wrote:
> > Fair enough, that does match the documentation of "size=0" better.
> > Though either way, someone who typos is going to get one kind of surprise
> > or another.  Do you mind if we do it slightly differently, achieving the
> > same effect without a special case, by rounding up instead of down?
> 
> Sounds reasonable to me. I didn't know about DIV_ROUND_UP :-)

I'm not familiar with it either (had to look it up to check it's
the right thing) - in mm/ we're accustomed to writing things like
"(size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT"; but that took
the line over 80 columns, and I dreaded someone somewhere mailing
in to ask "Why didn't you use DIV_ROUND_UP?" ;-)

Hugh
