Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZA3GWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZA3GWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 01:22:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbZA3GWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 01:22:22 -0500
Received: from kroah.org ([198.145.64.141]:44718 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751367AbZA3GWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 01:22:22 -0500
Date: Thu, 29 Jan 2009 22:20:10 -0800
From: Greg KH <greg@kroah.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Arve =?utf-8?B?SGo/bm5lduiZjQ==?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha =?utf-8?B?WXJqP2zjg7s=?= <juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com, Trilok Soni <soni.trilok@gmail.com>
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090130062010.GD31209@kroah.com>
References: <20090129134233.A95C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090129045916.GA24842@kroah.com> <20090129141238.A962.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129141238.A962.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 02:29:05PM +0900, KOSAKI Motohiro wrote:
> > > > > > I never expected it to be merged. I wrote it to allow us to ship a product.
> > > > > > 
> > > > > Then, please write "DON'T MERGE ME" on the top of patch description.
> > > > > we can adjust our viewpoints.
> > > > 
> > > > The code will live in the drivers/staging/ directory for now and not get
> > > > merged into the "main" portion of the kernel tree until everyone can
> > > > agree on it.
> > > > 
> > > > But for now, it is useful and seems to work for a few million devices
> > > > out there, so we can't just ignore it :)
> > > 
> > > No. 
> > > if author don't hope review and merge, we don't have any reason to reviewing.
> > 
> > I don't think you understand the goal/model for the drivers/staging/
> > subdirectories.  This is where "drivers" and other stand-alone chunks of
> > code live while they are not yet up to the real mergable status for the
> > rest of the kernel tree.  
> 
> I think staging is great activity, but I also think it is no good idea 
> for kernel core piece.
> 
> > While there, they get cleaned up, fixed up,
> > and then hopefully, merged into the main portion of the kernel tree when
> > the proper subsystem maintainers say it is ok.
> 
> The fact is simple more. if auther refuse to receive reviewing,
> the code don't clean up at all, don't fix up at all.
> then, dropping is better.

But that's not true at all.  And I'll be glad to fix up anything, I just
need to make sure that the system still will work properly when doing
so.

> > Whenever code in these directories is loaded, it taints the kernel with
> > a TAINT_CRAP flag so that everyone involved knows to ignore any bug
> > reports.
> > 
> > So while a review would be wonderful to have, it's not being asked for
> > for this specific low-memory "driver".  I'd like to see your final
> > version of what you proposed a while ago, if that goes into the kernel
> > tree, then this chunk of code will merely be deleted entirely.
> > 
> > Hope this helps explain things better,
> 
> Again, I respect for your drivers/staging activity largely.
> then, I don't oppose any driver merge to staging.

thanks.

> but I don't think driver/staging is good place for non driver code.
> The problem is, any patch must be reviewed by stakeholder, not maintenar only.
> then, the patch should post lkml and subsystem mailing list at first.
> 
> I like reviewed code than unreviewed code.

Heh, so do I.

And this is an odd "driver", I do know that.

But it solves a real problem that can't be solved any other way
currently, which is needed for a real system that is shipping.  So, if
it can't be solved any other way, do you have a way this kind of thing
could be more "correct"?

thanks,

greg k-h
