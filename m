Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbYJQSus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbYJQSus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758014AbYJQStb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:49:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:50473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006AbYJQSta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:49:30 -0400
Date: Fri, 17 Oct 2008 11:01:33 -0700
From: Greg KH <gregkh@suse.de>
To: Jason Baron <jbaron@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@elte.hu, yhlu.kernel@gmail.com, tglx@linutronix.de
Subject: Re: [GIT PATCH] driver core patches for your 2.6-git tree
Message-ID: <20081017180133.GB2429@suse.de>
References: <20081016170954.GA11824@kroah.com> <20081017153151.GB3167@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017153151.GB3167@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 11:31:51AM -0400, Jason Baron wrote:
> 
> One concern, raised in the other thread was that subsystems might want
> to use their own defined tags, as opposed to KBUILD_MODNAME, which is
> used by default to group together debugging control. Layering this tag
> ability on top of this patchset is not hard, and I already have patches
> which begin to do that.

That sounds like a useful thing to have.

> Also, this patch allows passing one command line argument to enable
> all debugging which can later be turn on/off as desired. This patch
> already stands on its own in enabling all pr_debug and dev_dbg calls
> to be dynamically enabled.

I tried turning everything on once.  The output was almost unusable, you
pretty much always want to be able to pick and choose what you want
enabled otherwise you drown in irrelevant data :)

thanks,

greg k-h
