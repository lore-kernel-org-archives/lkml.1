Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZA3GmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZA3GmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 01:42:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZA3Glw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 01:41:52 -0500
Received: from smtp-out.google.com ([216.239.45.13]:57355 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbZA3Glv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 01:41:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:organization:
	user-agent:x-gmailtapped-by:x-gmailtapped;
	b=JrmvGx/SqfAVXEv3+tGgHVt6mF/eRWzMJHlS6ap3NDtdLCCx3RwZ9jLOza5hjE+Wn
	WieYrxpkkrdiZzxlqVwBw==
Date: Thu, 29 Jan 2009 22:41:13 -0800
From: Brian Swetland <swetland@google.com>
To: Greg KH <greg@kroah.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Arve =?utf-8?B?SGo/bm5lduiZjQ==?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       arve@google.com, San Mehat <san@android.com>,
       Robert Love <rlove@google.com>, linux-kernel@vger.kernel.org,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>,
       ext Juha =?utf-8?B?WXJqP2zjg7s=?= <juha.yrjola@solidboot.com>,
       viktor.rosendahl@nokia.com, Trilok Soni <soni.trilok@gmail.com>
Subject: Re: lowmemory android driver not needed?
Message-ID: <20090130064113.GB7870@bulgaria.corp.google.com>
References: <20090129134233.A95C.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090129045916.GA24842@kroah.com> <20090129141238.A962.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090130062010.GD31209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130062010.GD31209@kroah.com>
Organization: Google, Inc.
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-GMailtapped-By: 172.25.146.36
X-GMailtapped: swetland
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Greg KH <greg@kroah.com>]
> > but I don't think driver/staging is good place for non driver code.
> > The problem is, any patch must be reviewed by stakeholder, not maintenar only.
> > then, the patch should post lkml and subsystem mailing list at first.
> > 
> > I like reviewed code than unreviewed code.
> 
> Heh, so do I.
> 
> And this is an odd "driver", I do know that.
> 
> But it solves a real problem that can't be solved any other way
> currently, which is needed for a real system that is shipping.  So, if
> it can't be solved any other way, do you have a way this kind of thing
> could be more "correct"?

I think a lot of the confusion here comes from Arve's earlier (very
terse) remark:  "I never expected it to be merged. I wrote it to allow 
us to ship a product."

At the risk of putting words in his mouth, I believe this should be
parsed as "we wrote this to solve problems necessary to ship products
and did not expect it to be merged to mainline as-is".  

We'd love to get support for low memory process killing that works for
our app model into the mainline.  If that's by reworking this driver
until it's acceptable or by implementing the same functionality a
different way, making use of some other subsystem, or whatever, we're
not particularly picky.  Our goal is, eventually, to maintain as few
patches outside of the kernel as possible so things can build "out of
the box."

Brian
