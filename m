Return-Path: <linux-kernel-owner+w=401wt.eu-S1760463AbZEFPdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760463AbZEFPdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755899AbZEFPdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:33:03 -0400
Received: from kroah.org ([198.145.64.141]:37482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbZEFPdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:33:00 -0400
Date: Wed, 6 May 2009 08:25:55 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] usb,early_printk: insert cr prior to nl as needed
Message-ID: <20090506152555.GB4603@kroah.com>
References: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com> <1241575205-12199-2-git-send-email-jason.wessel@windriver.com> <1241575205-12199-3-git-send-email-jason.wessel@windriver.com> <1241575205-12199-4-git-send-email-jason.wessel@windriver.com> <20090506073025.GB17457@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506073025.GB17457@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 09:30:25AM +0200, Ingo Molnar wrote:
> 
> * Jason Wessel <jason.wessel@windriver.com> wrote:
> 
> > The rs232 drivers send a carriage return prior to a new line in the
> > early printk code.
> > 
> > The usb debug driver should do the same because you want to be able to
> > use the same terminal programs and tools for analysis of early printk
> > data.
> > 
> > Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> > ---
> >  arch/x86/kernel/early_printk.c |   22 ++++++++++++++++------
> >  1 files changed, 16 insertions(+), 6 deletions(-)
> 
> hm, would be better to carry this in the x86 tree - where most of 
> the early-debug functionality has been authored and maintained. 
> 
> Greg, is that fine with you?

Yes, but it needs a few more rounds to fix the bugs pointed out.  So
please don't take this one yet.

thanks,

greg k-h
