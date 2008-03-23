Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbYCWSOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbYCWSOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 14:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYCWSN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 14:13:56 -0400
Received: from n75.bullet.mail.sp1.yahoo.com ([98.136.44.51]:28208 "HELO
	n75.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751941AbYCWSN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 14:13:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 304818.18678.bm@omp508.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=KUDuThwkIsH1aZYk5gD05mkowWfiyJ8HBuJ0GbxSsfeVVCLHLuX+BYXxJxEHHrNmVFfbyjLgrS2iKVGwSXfhvnz78mKDltBd/3mKTDLNmvj54NsI/luKcyGG/8c+Hyxa9GpCyP1SDiXXgjjB8MTsImvcYcyUs+rgvQoGiidgB8Y=;
X-YMail-OSG: WcfdVikVM1l6TKRvX.MCsMarNjx5VfpAX4qGKjJeOH_SOMF8cHgz8kztYDWlLe6_cNUN8nugbP9spCP.7rDvIgyuSwB95JUZxkq5
Date: Sun, 23 Mar 2008 11:13:55 -0700 (PDT)
From: "John T." <j.thomast@yahoo.com>
Subject: Re: UTF-8 and Alt key in the console
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
In-Reply-To: <47E69974.5000208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <205509.99433.qm@web45710.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "H. Peter Anvin" <hpa@zytor.com> wrote:

> John T. wrote:
> > 
> > OK, let's see if I can answer this.
> > 
> > Vi has 32 years of ESC key use tradition which doesn't play
> > well with "meta sends ESC".
> > 
> > Even though "meta sets 8th bit" is "broken" in your point-of-view,
> > that didn't stop it from being used all these years. The fact
> > that it maps into real characters is not a problem if you can just
> > use a CTRL-V equivalent in bash or vim.
> > 
> > Furthermore, it is an _option_. No one is obliged to use it.
> > So it's a question of:
> > 
> > .. _forcing_ the end of "meta sets 8th bit"
> > .. leaving things the way they are, and have them keep working,
> >  as xterm did.
> > 
> > So guess we should fix xterm too?
> > 
> > I think you're exagerating.
> > 
> 
> Hardly.  vim clearly can deal with the ESC-is-prefix issue anyway, since 
> otherwise it wouldn't be able to use arrow keys.

There's always the "timeout" hack. It is allright with the
arrow and function keys because the second character in these
cases (`[' usually) is not a commonly typed vim command.

> That being said, quite frankly, *both* Meta key conventions are 
> incredibly broken.

Indeed, I agree with you here.

> What I would much prefer is to see would be a brand new convention where 
> different keys (Ctrl, Meta, Super, Hyper, Alt or even in some cases 
> Shift) issues a unique prefix which doesn't conflict with anything else. 
>   Emacs has tried to promote such a convention of the format
> <CAN> @ <bucky> <keystroke> which is a lot better, although it's a bit 
> Emacs-centric (using <CAN> / ^X as the initial character is not really a 
> very good choice.)
> 
> The best probably would be to introduce an escape code, along the lines 
> of other escape codes in the terminal interfae.

You're right.

Many say Unix is also broken compared to Plan 9.. sometimes it's
too late. The real fix for this issue seems like it'd be very
hard to accomplish. In the meantime, maybe we could do this easy
fix. Or not. But we have a situation.

> 	-hpa
> 



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ

