Return-Path: <linux-kernel-owner+w=401wt.eu-S1763819AbZAPQJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763819AbZAPQJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbZAPQJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:09:31 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:42545 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZAPQJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:09:30 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
Date: Fri, 16 Jan 2009 11:09:27 -0500
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "SE-Linux" <selinux@tycho.nsa.gov>
References: <496D759A.7010401@gmail.com> <200901151752.06622.paul.moore@hp.com> <dd18b0c30901151644q4578f7d6k3023cad6f05325dd@mail.gmail.com>
In-Reply-To: <dd18b0c30901151644q4578f7d6k3023cad6f05325dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161109.27222.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009 7:44:15 pm Justin Mattock wrote:
> On Thu, Jan 15, 2009 at 2:52 PM, Paul Moore <paul.moore@hp.com> wrote:
> > Well, it is possible that /bin/sh points to a non-bash shell but
> > maybe not (I'm pretty sure the make command executes the scripts
> > with /bin/sh).  Either way, I checked in the fix to the SVN tree
> > earlier today so newer releases will have the fix; if needed I can
> > release a 0.19.1 or similar but I want to wait and see how
> > widespread the problem is ...
> >
> > --
> > paul moore
> > linux @ hp
>
> Cool, If I see anybody
> struggling, I point them to the
> fix you posted.

Great.  Also let me know, if this looks like it will be widespread 
problem I'll make a new release; I'd hate for people to have to patch 
the Makefile to get it to build ...

> I also might be missing something, i.g.
> one of the boxes that gave this error I built
> with debootstrap, but then the other that gave this as well
> was built with nubuntu which seems more complete
> than debootstrap.
> but then maybe both are missing a package.
> (or it's a debian thing)

It could also be my rather poor understanding of bash and makefiles :)  
If anyone out there wants to take a look and offer an explanation or a 
better patch I'm more than happy to accept it.

-- 
paul moore
linux @ hp
