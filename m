Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYAHUvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYAHUvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYAHUvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:51:46 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:42012 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbYAHUvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:51:45 -0500
Date: Tue, 8 Jan 2008 21:51:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rik van Riel <riel@redhat.com>
Cc: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org
Subject: Re: [PATCH 3/5] x86: coding style fixes in arch/x86/ia32/ia32_aout.c
Message-ID: <20080108205149.GA26794@uranus.ravnborg.org>
References: <20080108203233.01bb5c7f@paolo-desktop> <20080108150439.6388028e@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108150439.6388028e@bree.surriel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 03:04:39PM -0500, Rik van Riel wrote:
> On Tue, 8 Jan 2008 20:32:33 +0100
> Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
> 
> > Fix plenty of coding style errors
> 
> Most of these kernel changes would probably get in the way of
> real development, making patches reject that would otherwise
> apply.
> 
> You did find one possible bug, though:
> 
> > @@ -467,9 +465,9 @@ static int load_aout_library(struct file *file)
> >  
> >  #ifdef WARN_OLD
> >  		static unsigned long error_time;
> > -		if ((jiffies-error_time) > 5*HZ)
> > -		{
> > -			printk(KERN_WARNING 
> > +		if ((jiffies-error_time) > 5*HZ) {
> > +
> > +			printk(KERN_WARNING
> >  			       "N_TXTOFF is not page aligned. Please convert library: %s\n",
> >  			       file->f_path.dentry->d_name.name);
> >  			error_time = jiffies;
> 
> You may want to look into the time_after() macro and make sure
> it is used here.

It is already fixed in the x86 tree in the mm branch.

So this part would conflict with ongoing development effort...

	Sam
