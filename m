Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbZKLSWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbZKLSWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZKLSWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:22:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbZKLSWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:22:35 -0500
Date: Thu, 12 Nov 2009 16:21:20 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Eran Liberty <liberty@extricom.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial_core: avoid Break bouncing
Message-ID: <20091112162120.45b33ecf@pedra.chehab.org>
In-Reply-To: <20091112175649.145cbf18@lxorguk.ukuu.org.uk>
References: <20091112140504.6daf3824@pedra.chehab.org>
	<20091112175649.145cbf18@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 12 Nov 2009 17:56:49 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> escreveu:

> On Thu, 12 Nov 2009 14:05:04 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> > From: Eran Liberty <liberty@extricom.com>
> > 
> > On some boxes, Break signal bounces, causing sysrq code to fail with some
> > serial interfaces.
> > 
> > A solution were posted on LKML in 2008:
> > http://lkml.indiana.edu/hypermail/linux/kernel/0809.2/0730.html
> > 
> > However, the fix weren't applied upstream.
> 
> Because it was NAKked at the time as it seemed to be a bug in Eran's
> hardware platform not a generic problem and also because it breaks
> autobauding on break as used by some (particularly older) software.
> 
> It's still NAKked and it would be helpful if people resubmitting old
> stuff also looked through the thread attached the original submission.

I did, but I haven't find any nack at the public archives I've checked. My
fault. Sorry about that.

> You seem to have a single case of a user with some kind of buggy uart or
> possibly other weirdness going on. That's probably worth investigating
> more deeply but the patch NAKked before is not the solution due to its
> side effects

I'll do a deeper analysis and come back with a patch only if I discover
something new about this issue.
> 
> (also btw it'll upset other people who script their sysrq stuff including
> breaks and don't expect strange timing limits)
> 
> NAK again


-- 

Cheers,
Mauro
