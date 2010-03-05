Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab0CEFmj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 00:42:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469Ab0CEFmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 00:42:38 -0500
Date: Thu, 4 Mar 2010 21:42:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <alpine.LFD.2.00.1003042130230.3768@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003042133340.3788@localhost.localdomain>
References: <20100304103929.6eb81d45@jbarnes-piketon>  <21d7e9971003041406n53d9cae0h53374abf3dca494e@mail.gmail.com>  <alpine.LFD.2.00.1003041554490.3751@localhost.localdomain>  <1267748927.3496.6.camel@nisroch>  <alpine.LFD.2.00.1003041635280.3751@localhost.localdomain>
  <20100305005617.GA31883@skynet.be>  <alpine.LFD.2.00.1003041702110.3659@localhost.localdomain>  <alpine.LFD.2.00.1003041718090.3768@localhost.localdomain>  <21d7e9971003041728u7f7477f4g16805bc1ee235e8f@mail.gmail.com>  <alpine.LFD.2.00.1003042114340.3768@localhost.localdomain>
 <21d7e9971003042122j4c19ad22odabfa1f4cd90503b@mail.gmail.com> <alpine.LFD.2.00.1003042130230.3768@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Mar 2010, Linus Torvalds wrote:
> On Fri, 5 Mar 2010, Dave Airlie wrote:
> > 
> > if not then:
> > http://people.fedoraproject.org/~airlied/xorg-x11-drv-nouveau-0.0.16-2.20100218git2964702.fc13.test.src.rpm
> > 
> > That src rpm should be rebuildable on F12, I just removed the requires
> > on F13 stuff.
> 
> Well, that wants the new kernel, but I can force it with --nodeps..
> 
> I'll reboot and test.

Bingo. 

Could this be done as a real F12 binary package (maybe call it 
"force-nouveau-0.0.16" or something) for testers to use? I had most of the 
X devel tools set up anyway since I used to build intel drivers from git 
for one of my experimental machines. And I guess most kernel devs can 
generally easily do the rpm build, but I'd hate to lose any more plain 
testers than I absolutely have to.

And it would make it way easier for people to try out their kernel, notice 
that X doesn't work, and then let them know that something like a simple

	yum install force-nouveau-0.0.16

makes it work. Compared to having them install X builds, do a "rpm -Uvh 
--nodeps" etc etc.

Anyway, this at least makes me feel like I don't have to revert that 
commit just to be able to test current -git again. Thanks,

			Linus
