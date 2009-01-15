Return-Path: <linux-kernel-owner+w=401wt.eu-S936260AbZAOXCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936260AbZAOXCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 18:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935581AbZAOWwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:52:14 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:32593 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935608AbZAOWwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:52:09 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
Date: Thu, 15 Jan 2009 17:52:06 -0500
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "SE-Linux" <selinux@tycho.nsa.gov>
References: <496D759A.7010401@gmail.com> <200901151246.38396.paul.moore@hp.com> <dd18b0c30901151400t68dfc54cu67a378ba71a2edc9@mail.gmail.com>
In-Reply-To: <dd18b0c30901151400t68dfc54cu67a378ba71a2edc9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151752.06622.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009 5:00:55 pm Justin Mattock wrote:
> On Thu, Jan 15, 2009 at 9:46 AM, Paul Moore <paul.moore@hp.com> wrote:
> > On Wednesday 14 January 2009 9:43:56 pm Justin P. Mattock wrote:
> >> Paul Moore wrote:
> >> > On Wednesday 14 January 2009 4:35:25 pm Justin P. Mattock wrote:
> >> >> here is what the error looks like:
> >> >>
> >> >> netlabel_tools-0.19# make
> >> >> INFO: creating the version header file
> >> >> .: 10: version_info: not found
> >> >> make: *** [include/version.h] Error 2
> >> >
> >> > Huh, can you try the following:
> >> >
> >> >  1. Open the netlabel_tools-0.19/Makefile in your favorite
> >> > editor 2. Change the ". version_info; \" line to "source
> >> > ./version_info; \" 3. Save your changes
> >> >  4. Try running "make" again
> >> >
> >> > Thanks.
> >>
> >> O.k. changed . version like how you had posted.
> >> The package compiled like a charm.
> >
> > Great, I'll change the Makefile(s) in SVN ... I don't quite
> > understand the reason (what is your /bin/sh?  I'm guessing not
> > bash?) but at least we now have a solution :)
> >
> > --
> > paul moore
> > linux @ hp
>
> hmm..
> under ps auxZ
> I see:
> 2896 tty1 S+ 0:00 /bin/bash /usr/bin/startx
> then open aterm for navigating.
>
> Thankfully it works(this people can install
> it a test it out.)

Well, it is possible that /bin/sh points to a non-bash shell but maybe 
not (I'm pretty sure the make command executes the scripts 
with /bin/sh).  Either way, I checked in the fix to the SVN tree 
earlier today so newer releases will have the fix; if needed I can 
release a 0.19.1 or similar but I want to wait and see how widespread 
the problem is ...

-- 
paul moore
linux @ hp
