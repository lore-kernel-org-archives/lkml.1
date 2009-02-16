Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZBPRXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZBPRXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 12:23:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbZBPRXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 12:23:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53374 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbZBPRXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:23:32 -0500
Date: Mon, 16 Feb 2009 12:23:18 -0500
From: Bill Nottingham <notting@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Declare PIO_CMAP/GIO_CMAP as compatbile ioctls.
Message-ID: <20090216172318.GB26018@nostromo.devel.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Jiri Kosina <jkosina@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org
References: <1234279525-25143-1-git-send-email-notting@redhat.com> <alpine.LNX.1.10.0902111438280.31014@jikos.suse.cz> <20090215134144.c29913d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215134144.c29913d9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(dropping trivial@ and stable@ cc's)

Andrew Morton (akpm@linux-foundation.org) said: 
> On Wed, 11 Feb 2009 14:41:25 +0100 (CET) Jiri Kosina <jkosina@suse.cz> wrote:
> 
> > On Tue, 10 Feb 2009, Bill Nottingham wrote:
> > 
> > > Otherwise, these don't work when called from 32-bit userspace on 64-bit kernels.
> 
> Bill, please remember to add signoffs?  This should all be scripted.

I would have expected that that would be the default in 'git format-patch'.
Will keep note of that for the future.

> > Could you please give your Acked-by for it so that I can 
> > merge, or take it through your tree completely?
> 
> afaict this fix is needed all the way back to 2.6.tiny.  I merged it
> with 2.6.29 intentions.  Also tagged as needed in 2.6.25.x and later.

So, is there some way to do static analysis on the kernel source to
find *all* ioctls that aren't marked as compatible, and don't have
specific compat handlers?

Bill
