Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZA2FBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZA2FBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 00:01:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbZA2FBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 00:01:24 -0500
Received: from kroah.org ([198.145.64.141]:55983 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750701AbZA2FBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 00:01:24 -0500
Date: Wed, 28 Jan 2009 20:59:16 -0800
From: Greg KH <greg@kroah.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Arve =?utf-8?B?SGrvv71ubmV26JmN?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       Brian Swetland <swetland@google.com>, arve@google.com,
       San Mehat <san@android.com>, Robert Love <rlove@google.com>,
       linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha =?utf-8?B?WXJq77+9bOODuw==?= 
	<juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com, Trilok Soni <soni.trilok@gmail.com>
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090129045916.GA24842@kroah.com>
References: <20090129124555.b83ea0ae.kamezawa.hiroyu@jp.fujitsu.com> <20090129042748.GA24108@kroah.com> <20090129134233.A95C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090129134233.A95C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 01:43:51PM +0900, KOSAKI Motohiro wrote:
> > > > I never expected it to be merged. I wrote it to allow us to ship a product.
> > > > 
> > > Then, please write "DON'T MERGE ME" on the top of patch description.
> > > we can adjust our viewpoints.
> > 
> > The code will live in the drivers/staging/ directory for now and not get
> > merged into the "main" portion of the kernel tree until everyone can
> > agree on it.
> > 
> > But for now, it is useful and seems to work for a few million devices
> > out there, so we can't just ignore it :)
> 
> No. 
> if author don't hope review and merge, we don't have any reason to reviewing.

I don't think you understand the goal/model for the drivers/staging/
subdirectories.  This is where "drivers" and other stand-alone chunks of
code live while they are not yet up to the real mergable status for the
rest of the kernel tree.  While there, they get cleaned up, fixed up,
and then hopefully, merged into the main portion of the kernel tree when
the proper subsystem maintainers say it is ok.

Whenever code in these directories is loaded, it taints the kernel with
a TAINT_CRAP flag so that everyone involved knows to ignore any bug
reports.

So while a review would be wonderful to have, it's not being asked for
for this specific low-memory "driver".  I'd like to see your final
version of what you proposed a while ago, if that goes into the kernel
tree, then this chunk of code will merely be deleted entirely.

Hope this helps explain things better,

greg k-h
