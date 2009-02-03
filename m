Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbZBCNka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbZBCNka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 08:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbZBCNkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 08:40:20 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43662 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbZBCNkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 08:40:19 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Brian Swetland <swetland@google.com>
Subject: Re: lowmemory android driver not needed?
Cc: kosaki.motohiro@jp.fujitsu.com, Greg KH <greg@kroah.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Arve =?ISO-2022-JP?B?SGo/bm5ldhskQmlIGyhC?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       arve@google.com, San Mehat <san@android.com>,
       Robert Love <rlove@google.com>, linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha =?ISO-2022-JP?B?WXJqP2wbJEIhJhsoQg==?= 
	<juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com, Trilok Soni <soni.trilok@gmail.com>
In-Reply-To: <20090130064113.GB7870@bulgaria.corp.google.com>
References: <20090130062010.GD31209@kroah.com> <20090130064113.GB7870@bulgaria.corp.google.com>
Message-Id: <20090203114855.EC9D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue,  3 Feb 2009 22:40:14 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> [Greg KH <greg@kroah.com>]
> > > but I don't think driver/staging is good place for non driver code.
> > > The problem is, any patch must be reviewed by stakeholder, not maintenar only.
> > > then, the patch should post lkml and subsystem mailing list at first.
> > > 
> > > I like reviewed code than unreviewed code.
> > 
> > Heh, so do I.
> > 
> > And this is an odd "driver", I do know that.
> > 
> > But it solves a real problem that can't be solved any other way
> > currently, which is needed for a real system that is shipping.  So, if
> > it can't be solved any other way, do you have a way this kind of thing
> > could be more "correct"?

I agree this patch address correct requirement.


> I think a lot of the confusion here comes from Arve's earlier (very
> terse) remark:  "I never expected it to be merged. I wrote it to allow 
> us to ship a product."
> 
> At the risk of putting words in his mouth, I believe this should be
> parsed as "we wrote this to solve problems necessary to ship products
> and did not expect it to be merged to mainline as-is".  

ok. I believe you.
I also hope that I'm working with various background guys.


thanks.

> We'd love to get support for low memory process killing that works for
> our app model into the mainline.  
>
> If that's by reworking this driver
> until it's acceptable or by implementing the same functionality a
> different way, making use of some other subsystem, or whatever, we're
> not particularly picky.  Our goal is, eventually, to maintain as few
> patches outside of the kernel as possible so things can build "out of
> the box."





