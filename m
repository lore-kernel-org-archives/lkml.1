Return-Path: <linux-kernel-owner+w=401wt.eu-S1756677AbYHGA4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbYHGA4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYHGA4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:56:41 -0400
Received: from ns.bitdefender.com ([91.199.104.10]:37295 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYHGA4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:56:40 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2008 20:56:39 EDT
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mdontu@bitdefender.com>
Organization: BitDefender
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Date: Thu, 7 Aug 2008 03:49:55 +0300
User-Agent: KMail/1.9.9
Cc: tvrtko.ursulin@sophos.com, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net
References: <20080806105008.GF6477@cs181140183.pp.htv.fi> <20080806110851.C2DBC3764CE@pmx1.sophos.com> <20080806112646.GG6477@cs181140183.pp.htv.fi>
In-Reply-To: <20080806112646.GG6477@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808070349.55882.mdontu@bitdefender.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.0.0 on
 mail.bitdefender.com, sigver: 7.20386
X-BitDefender-Spam: No (0)
X-BitDefender-SpamStamp: v1, build 2.6.17.51188, bayes score: 500(0),
 pbayes score: 0(0), neunet score: 0(0), flags: [VALID_REPLY], total:
 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2008, Adrian Bunk wrote:
> On Wed, Aug 06, 2008 at 12:07:57PM +0100, tvrtko.ursulin@sophos.com wrote:
> > Adrian Bunk <bunk@kernel.org> wrote on 06/08/2008 11:50:08:
> > > As an observer of this thread:
> > >
> > > - Some set of requirements suddenly appears out of the void on
> > >   linux-kernel.
> >
> > Because previously it was said to go away and come back with a clear list
> > of requirements. And here you make it sound like a negative thing. See
> > what I am talking about?
>
> Both of my points belong together.
>
> > > - Noone is able and/or willing to exactly describe the problem(s) they
> > >   are trying to solve.
> >
> > Hopefully we will get there. Very little time has passed since the
> > discussion has started, even less considering the time zone difference
> > for some.
> >
> > > With this status quo the discussion is going nowhere - Linux kernel
> > > development does not work this way.
> > >
> > > The aim is not to include this code, but to find the best technical
> > > solution for your problem(s) - no matter whether this will have
> > > anything in common with the list of requirements and the code posted or
> > > not.
> >
> > I completely agree with that. Here I was just pointing out that what Greg
> > wrote was untrue and exaggerated so not helping the discussion at all.
>
> Until now the main discussion participant from the AV side is
> Jonathan Press.

Well, if you insist, but I must state that this mail represents my own opinion 
and not my employer's (that's because all the people I could consult with are 
sleeping :) ).

> But the real discussion hasn't even started since the information
> required is not available.
>
> And as soon as the information for the real discussion is available all
> these initial discussions become irrelevant.

> - Noone is able and/or willing to exactly describe the problem(s) they
>   are trying to solve.

Well, here is one attempt.

A good percentage of an AV product's job is to prevent exploitation of a 
security hole in a product before the vendor (assuming the vendor admits it's 
bug and not a misuse of the product's features).

Most distribution makers go through a lot of work before releasing an update, 
which might take days. Add to this the fact that some users refuse to update 
periodically (because one operating system out there shattered the belief in 
this practice) and that some of them are willing to pay to not care. This is 
reason enough for most AV vendors.

In the present, on the Linux Desktop, this is [still] hypothetical talk and 
God help it will remain so. However, if there is one incredibly small chance 
that one (new?) type of malware can spread to a large number of users, then 
AV vendors will race for creating a solution because there will _definitely_ 
be people needing help with this (please notice that the IQ scale starts from 
zero and not from 130 :) ).

I think this patch is trying to do what dazuko hasn't managed to do (yet): get 
into mainline. :)

-- 
Mihai Donțu
