Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbZA2F3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbZA2F3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 00:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbZA2F3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 00:29:13 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54502 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbZA2F3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 00:29:11 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Greg KH <greg@kroah.com>
Subject: Re: lowmemory android driver not needed?
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Arve =?ISO-2022-JP?B?SGo/bm5ldhskQmlIGyhC?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha =?ISO-2022-JP?B?WXJqP2wbJEIhJhsoQiA=?= 
	<juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com, Trilok Soni <soni.trilok@gmail.com>
In-Reply-To: <20090129045916.GA24842@kroah.com>
References: <20090129134233.A95C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090129045916.GA24842@kroah.com>
Message-Id: <20090129141238.A962.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 29 Jan 2009 14:29:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > I never expected it to be merged. I wrote it to allow us to ship a product.
> > > > > 
> > > > Then, please write "DON'T MERGE ME" on the top of patch description.
> > > > we can adjust our viewpoints.
> > > 
> > > The code will live in the drivers/staging/ directory for now and not get
> > > merged into the "main" portion of the kernel tree until everyone can
> > > agree on it.
> > > 
> > > But for now, it is useful and seems to work for a few million devices
> > > out there, so we can't just ignore it :)
> > 
> > No. 
> > if author don't hope review and merge, we don't have any reason to reviewing.
> 
> I don't think you understand the goal/model for the drivers/staging/
> subdirectories.  This is where "drivers" and other stand-alone chunks of
> code live while they are not yet up to the real mergable status for the
> rest of the kernel tree.  

I think staging is great activity, but I also think it is no good idea 
for kernel core piece.

> While there, they get cleaned up, fixed up,
> and then hopefully, merged into the main portion of the kernel tree when
> the proper subsystem maintainers say it is ok.

The fact is simple more. if auther refuse to receive reviewing,
the code don't clean up at all, don't fix up at all.
then, dropping is better.


> Whenever code in these directories is loaded, it taints the kernel with
> a TAINT_CRAP flag so that everyone involved knows to ignore any bug
> reports.
> 
> So while a review would be wonderful to have, it's not being asked for
> for this specific low-memory "driver".  I'd like to see your final
> version of what you proposed a while ago, if that goes into the kernel
> tree, then this chunk of code will merely be deleted entirely.
> 
> Hope this helps explain things better,

Again, I respect for your drivers/staging activity largely.
then, I don't oppose any driver merge to staging.

but I don't think driver/staging is good place for non driver code.
The problem is, any patch must be reviewed by stakeholder, not maintenar only.
then, the patch should post lkml and subsystem mailing list at first.

I like reviewed code than unreviewed code.



