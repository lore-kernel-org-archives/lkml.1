Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbXIPVMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbXIPVMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 17:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbXIPVM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 17:12:28 -0400
Received: from THUNK.ORG ([69.25.196.29]:39696 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbXIPVM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 17:12:27 -0400
Date: Sun, 16 Sep 2007 17:12:08 -0400
From: Theodore Tso <tytso@mit.edu>
To: Adrian Bunk <bunk@kernel.org>, "Can E. Acar" <can.acar@pro-g.com.tr>,
       misc@openbsd.org, linux-kernel@vger.kernel.org,
       Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070916211208.GC5502@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Adrian Bunk <bunk@kernel.org>,
	"Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
	linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
	Eben Moglen <moglen@softwarefreedom.org>,
	Lawrence Lessig <lessig_from_web@pobox.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070916203926.GA17863@schlund.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 10:39:26PM +0200, Hannah Schroeter wrote:
> >The most questionable legal advice in this thread was by Theo de Raadt 
> >who claimed choosing one licence for _dual-licenced_ code was illegal...
> 
> JFTR, I do *not* think that that assessment was questionable. Unless the
> dual-licensing *explicitly* allows relicensing, relicensing is forbidden
> by copyright law. The dual-licensing allows relicensing only if that's
> *explicitly* stated, either in the statement offering the alternative, or
> in one of the licenses.
> 
> Neither GPL nor BSD/ISC allow relicensing in their well-known wordings.
> 
> If you think that's questionable, you should at least provide arguments
> (and be ready to have your interpretation of the law and the licenses
> tested before court).

Hannah,

What is going on whenever someone changes a code is that they make a
"derivative work".  Whether or not you can even make a derivative
work, and under what terms the derivitive work can be licensed, is
strictly up to the license of the original.  For example, the BSD
license says:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met....

Note the "with or without modification".  This is what allows people
to change BSD licensed code and redistribute said changes.  The
conditions specified by the BSD license do not mention anything about
licening terms --- just that if you meet these three conditions, you
are allowed to redistribute them.  So for example, this is what allows
Network Appliances to take BSD code, change it, and add a restrictive,
proprietary copyright.

So for code which is single-licensed under a BSD license, someone can
create a new derived work, and redistribute it under a more
restrictive license --- either one as restrictive as NetApp's (where
no one is allowed to get binary unless they are a NetApp customer, or
source only after signing an NDA), or a GPL license.  It is not a
relicencing, per se, since the original version of the file is still
available under the original copyright; it is only the derived work
which is under the more restrictive copyright.   

Now, the original copyright can say that you aren't allowed to do
this; for example, the GPL says that you are not allowed to add any
restrictions on the copyright license of any derived works of GPL'ed
code.  This is why some BSD partisans claim that their license is
"more free"; the BSD license allows people to add more restrictive
copyright license terms on derived works.

OK, what about dual licensed works?  The specific wording of the dual
licensing is that you can use *either* license.  That means, you can
treat code as if only using the BSD license applied, or only if the
GPL license applied.  That is, the end-user can redistribute if either
the conditions required by the BSD license *or* the GPL license
applied.  But we've already shown that the BSD license allows the
creation of a derived work with a more restrictive license --- such as
the GPL.

But don't take my word for it; the Software Freedom Law Center has
issued advice, pro bono, written by lawyers about how this can be
done.  If you want, feel free get your own lawyers and ask them to
provide formal legal advice.

> A difference is, GPL requires it under every circumstance. BSD does not,
> indeed. But how should one expect it from *OSS* people that even *they*
> don't give back? Do you really want to put yourself on the same level as
> closed-source companies?

The problem with your argument is that BSD folks have claimed that the
BSD license is morally superior --- "more free than the GPL" ---
because you don't have to "give back" (or more formally, create a
derivitive work with a copyright license more restrictive than the
BSD).  If that is true, it is the absolute height of hypocrisy to
suddenly start complaining when code is restricted via an another open
source license such as the GPL, but not complain when NetApp uses BSD
code to make million and millions of dollars without giving anything
of substantial value back.  At least in the case of GPL'ed code you
still can look at the changes and decide how and whether you to
reimplement them.  Why don't you go and try asking NetApp for sources
to WAFL, and claim that they have "moral" duty to give the code back,
and see how quickly you get laughed out of the office?

    	    	    	    	    	   - Ted
