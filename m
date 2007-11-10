Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbXKJWYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbXKJWYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 17:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXKJWYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 17:24:23 -0500
Received: from mx.treblig.org ([80.68.94.177]:3663 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754755AbXKJWYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 17:24:22 -0500
X-Greylist: delayed 1159 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Nov 2007 17:24:21 EST
Date: Sat, 10 Nov 2007 22:24:14 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM ML <linux-security-module@vger.kernel.org>,
       apparmor-dev <apparmor-dev@forge.novell.com>
Subject: Re: AppArmor Security Goal
Message-ID: <20071110222414.GC24195@gallifrey>
References: <473380AD.5070801@crispincowan.com> <20071110220455.GB24195@gallifrey> <47362C7C.2050202@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47362C7C.2050202@crispincowan.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.20.3-bytemark-uml-2 (i686)
X-Uptime: 22:18:10 up 16 days, 12:47,  2 users,  load average: 0.64, 0.70, 0.61
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Crispin Cowan (crispin@crispincowan.com) wrote:
> Dr. David Alan Gilbert wrote:
> > * Crispin Cowan (crispin@crispincowan.com) wrote:
> > <snip
> >>     * Manipulating AppArmor policy requires being both root privileged
> >>       and not being confined by AppArmor, thus there is explicitly no
> >>       capability for non-privileged users to change AppArmor policy.
> >>     
> > It's a pity that there is no way to do this; it would be nice to restrict
> > web browsers, document editors etc but allow them
> > to access the places you commonly store documents etc.
> >   
> I don't get the problem: if you want your web browser to be able to
> access where you commonly store your documents, then give it that
> permission. The above rule says that your web browser doesn't get to go
> change AppArmor policy on its own.

But can I as a non-privileged user say which directories I want it to
be able to access?

> I have serious doubts about the utility of restricting a text editor.
> You nominally want to be able to edit any file on the system, so
> confining it would be fairly meaningless.

Text editor probably true; but I'm thinking here more of OpenOffice
and the like; there have been plenty of document carried malware in the
past.

> > Similarly I'd like to be able to split applications so that
> > the 'preferences' editing facilities are done by separate
> > envrionments so that there is no way that a fault in parsing
> > external data could edit the config (e.g. change home page or
> > proxy in a browser or default document in an editor).
> >   
> AppArmor will let you do that; most of the work is in splitting the
> application. If you can get e.g. Firefox to use a separate process that
> it exec's for editing your preferences, then AppArmor can confine that
> helper app with a different policy than Firefox itself, including
> granting the helper write permission to the config directory.

Yes, and designing the app so that it's filenames are predictable;
firefox has a fun habit of using randomly named profile directories.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
