Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbXHUUXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbXHUUXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbXHUUXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:23:00 -0400
Received: from iona.labri.fr ([147.210.8.143]:50511 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbXHUUW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:22:59 -0400
Date: Tue, 21 Aug 2007 22:22:51 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       dtor@mail.ru, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Console keyboard events and accessibility
Message-ID: <20070821202251.GB3658@interface.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
	dtor@mail.ru, Jiri Kosina <jkosina@suse.cz>
References: <20070821005718.GD3658@interface.famille.thibault.fr> <20070821130233.58faaa8a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070821130233.58faaa8a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton, le Tue 21 Aug 2007 13:02:33 -0700, a écrit :
> On Tue, 21 Aug 2007 02:57:18 +0200
> Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> 
> > Some external modules like Speakup need to use the PC keyboard to control
> > them and also need to get keyboard feedback (caps lock status, etc.)
> > 
> > This adds a keyboard notifier that such modules can use to get the keyboard
> > events and possibly eat them, at several stages:
> 
> Adding hooks for non-merged modules is considered sinful.  Making these new
> exports EXPORT_SYMBOL_GPL might ease the pain.

That should be fine.

I'll soon propose a notifier for the console writes too, same story.

> Is there any prospect of getting at least one of these "external modules
> like Speakup" merged into mainline?

I'm working on it.  The problem is that the current code quality is
still far from mainline requirements (though improving over time).  This
hook (and the other one I'll post) is a step toward merging.  If these
hooks can go mainline, then great, that will make life easier for the
few distributions that want to provide speakup as modules.  If they
remain in -mm for some time and people don't complain, well that's good
too: at least we know how speakup may hook into the kernel when it gets
merged.

Working on braille support is also in my plan BTW.

Samuel
