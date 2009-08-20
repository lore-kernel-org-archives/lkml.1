Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbZHTCub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbZHTCub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZHTCua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:50:30 -0400
Received: from kroah.org ([198.145.64.141]:60684 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZHTCu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:50:29 -0400
Date: Wed, 19 Aug 2009 19:48:39 -0700
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Robin Getz <rgetz@blackfin.uclinux.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the usb tree with the tip tree
Message-ID: <20090820024839.GA4121@kroah.com>
References: <20090819175901.59f1af9e.sfr@canb.auug.org.au>
 <20090819233818.GD2875@kroah.com>
 <4A8CB6CF.3010109@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8CB6CF.3010109@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 09:37:03PM -0500, Jason Wessel wrote:
> Greg KH wrote:
> > On Wed, Aug 19, 2009 at 05:59:01PM +1000, Stephen Rothwell wrote:
> >   
> >> Hi Greg,
> >>
> >> Today's linux-next merge of the usb tree got a conflict in
> >> kernel/printk.c between commit 4d09161196c9a836eacea4b36e2f217bc34894cf
> >> ("printk: Enable the use of more than one CON_BOOT (early console)") from
> >> the tip tree and commit e289e7dc72eb6bfce70e2722d97a00f5e02893e8 ("USB:
> >> printk: early_printk,console: Allow more than one early console") from
> >> the usb tree.
> >>
> >> I assume that these are trying to do (more or less) the same thing.  I
> >> have dropped the one from the usb tree for today.  Please sort this out -
> >> at least remove the usb tree one until you have done so, thanks.
> >>     
> >
> > Jason, any thoughts?  I'm going to drop your printk stuff from my tree
> > now, care to sort it out and resend your whole series?
> >
> >   
> 
> I will investigate, re-test and send a new series to Greg KH later in
> the week.  The preliminary result shows the problem is a result of a
> clash with two different patches in the tip tree.   My patch set and the
> two patches it collides with context wise fix different things.
> 
> In order to resolve this it appears that the series will need to get
> split into something for the tip tree and something for the USB tree, or
> we wait for the next pull of the tip branch into the Linus's tree.

Hm, I'd prefer to get this in before that :)

Let me know what you find.  If there are conflicts, we can work it out.

thanks,

greg k-h
