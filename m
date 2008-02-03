Return-Path: <linux-kernel-owner+w=401wt.eu-S935397AbYBCAxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935397AbYBCAxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753755AbYBCAw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:52:57 -0500
Received: from keil-draco.com ([216.193.185.50]:50176 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYBCAw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:52:56 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Improve Documentation/stable_api_nonsense.txt v2
Date: Sat, 2 Feb 2008 19:52:37 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Heikki Orsila <shdl@zakalwe.fi>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, ak@suse.de, m-ikeda@ds.jp.nec.com, zhongyu@18mail.cn,
       minchan.kim@gmail.com
References: <20080202144457.653482BC98@zakalwe.fi> <20080203002249.GB3453@kroah.com>
In-Reply-To: <20080203002249.GB3453@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802021952.37848.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008 19:22:49 Greg KH wrote:
> On Sat, Feb 02, 2008 at 04:44:57PM +0200, Heikki Orsila wrote:
<snip>
> > @@ -145,6 +145,10 @@ as small as possible, and that all potential
> > interfaces are tested as well as they can be (unused interfaces are
> > pretty much impossible to test for validity.)
> >
> > +However, changing an interface can be delicate work and it can take
> > +significant amount of developer effort. Therefore, an interface is
> > +not changed unless the change is regarded as very important by the
> > +developers.
> >
> >  What to do
> >  ----------
>
> I still don't understand why you want to add these sentances.  Why are
> they needed?  Are people thinking that the kernel developers just
> randomly change things just because they are bored and have nothing else
> to do at the moment?  Do people think that our changes are gratuitous?
>
> Even so, I don't think this needs to be added, we have already stated
> many good reasons why changing apis are necessary and good.  Do need to
> add another one?
>
> thanks,
>
> greg k-h

Actually, Greg, a hell of a lot of people that don't track linux kernel 
development do think that way. And there are always going to be people that 
think that way.

As it stands the recommended paragraph does clarify that, while the interfaces 
aren't stable, can and will change as needed, there are some core interfaces 
that *WON'T* change without a very good reason. Having such a public 
statement that anyone can see and people can point to is another weapon to 
help people fight the FUD that exists around Linux.

DRH
(And yes, I do fight anti-linux FUD all the time. My parents have been using 
my laptops and can actually be quoted as saying that the next computer they 
buy will run Linux! My family mostly runs Windows - my brothers because their 
kids would complain about not being able to play their games and my sister 
because her husband is so computer illiterate I'm amazed he actually knows 
how to do a Google search)

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
