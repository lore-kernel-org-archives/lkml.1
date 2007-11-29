Return-Path: <linux-kernel-owner+w=401wt.eu-S932659AbXK2QkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659AbXK2QkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932186AbXK2QkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:40:00 -0500
Received: from pmx2.sophos.com ([213.31.172.17]:54761 "EHLO pmx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbXK2Qj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:39:59 -0500
In-Reply-To: <p738x4i9nyd.fsf@crumb.suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.5 November 30, 2005
Message-ID: <OFFB86F10D.D565B603-ON802573A2.005A558C-802573A2.005B85B0@sophos.com>
From: tvrtko.ursulin@sophos.com
Date: Thu, 29 Nov 2007 16:39:54 +0000
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.2FP1|January 10, 2007) at
 29/11/2007 16:39:57,
	Serialize complete at 29/11/2007 16:39:57
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ak@suse.de wrote on 28/11/2007 19:20:26:

> "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com> writes:
> 
> > We here at Sophos (the fourth largest endpoint security vendor in 
> the world) 
> > have such a module called Talpa which is a part of our main 
> endpoint security 
> > product
> 
> What is a "endpoint security product" exactly? A gateway that scans
> files passing through it?

No, it would be more like a desktop/workstation thingy which protects 
against different kinds of malware and can also enforce policies, all 
centraly managed. I am afraid to use to more marketing words not to upset 
the LKML filters because originaly my posdt was blocked on.. hah! I almost 
wrote it now! :) It was "security vendor" but with another term for 
vendor.
 
> > In essence, what our module does is it intercepts file accesses and 
allows 
> > userspace daemons to vet them.
> 
> I suspect the only good way forward would be to collect the
> requirements of your user space and then define a proper official
> interface to do what they want to do. Ideally would be a shared proposal
> from multiple groups who are doing this, e.g. if you could talk to
> some others doing similar things that would be best.

I completely agree and effort to do that is under way. I am not the one 
coordinating that but hopefully those who are will post something soon.
 
> Personally I admit I never quite saw the point of intercepting all
> file accesses for everything. That will just always be slow as often
> demonstrated on other operating systems and racey and unreliable too.
> And at least the internal daemons should be already reasonably well
> protected by standard (or beyond standard, like AA/SELinux etc.)
> security measures, so e.g. it does not really make sense to intercept
> all of your /etc file accesses and similar.

Personally I don't know. I am often surprised when I hear what techniques 
the bad guys use and what is possible.

Solution that we currently have is not so slow (btw you are free to try it 
out). And by working on a proper interface race and reliability issues 
should be solvable.
 
> It might be better to identify the services (gateway, samba, file
> server whatever) that are actually dealing with possible infected
> "external" files and then define some generic interface that would
> allow you to check those as the data appears.
> 
> I would expect such an approach to perform better in the end and be more
> reliable too.
> 
> Note such a interface might well be user space only.

That is fine for some classes of servers. But for some other and desktop 
more could be needed. 

--
Tvrtko August Ursulin
Senior Software Engineer, Sophos

"Views and opinions expressed in this email are strictly those of the 
author.
 The contents has not been reviewed or approved by Sophos."

Tel: 01235 559933
Web: www.sophos.com
Protecting business against viruses, spyware, spam and policy abuse


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

