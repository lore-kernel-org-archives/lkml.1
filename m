Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbXF0NmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbXF0NmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 09:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbXF0Nl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 09:41:57 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44796 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbXF0Nl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 09:41:56 -0400
Date: Wed, 27 Jun 2007 08:41:49 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Andreas Gruenbacher <agruen@suse.de>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH try #2] security: Convert LSM into a static interface
Message-ID: <20070627134149.GB2679@sergelap>
References: <20070617135239.GA17689@sergelap> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706250031350.15974@localhost.localdomain> <200706252237.59226.agruen@suse.de> <11C35822-4E11-4365-BADE-C1AE41F15B50@mac.com> <20070626134712.GA8615@sergelap.austin.ibm.com> <B189F69D-B63E-4EE3-8580-39C8AFA97E5A@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B189F69D-B63E-4EE3-8580-39C8AFA97E5A@mac.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kyle Moffett (mrmacman_g4@mac.com):
> This whole discussion boils down to 2 points:

Yes it can, but not the two you list.

>   1) As currently implemented, no LSM may be safely rmmod-ed

That's not the rationale for the patch, it's just some talking point you
picked up.  The rationale for the patch is to prevent abuse.  So point 1
is

	1) Is the LSM infrastructure being abused, and how detrimental
	   is that abuse

As has come up, the abuse comes in two forms, and people seem to want to
blur the two forms to make it seem especially relevant and heinous...

>   2) Someone has submitted a patch which fixes that problem (you  
> can't rmmod them at all, so no crashes)

	2) Is the loss of flexibility in the LSM framework a worthwhile
	   tradoff against the abuse prevention.

Clearly I and a very few others feel no, and a very vocal set (which
sure sounds like a majority) says yes.

Now quit trying to give technical justifications for something which is
technical only insofar as it is a technical roadblock to prevent a legal
problem.

> If you really want to do modular LSMs, then you need to submit a  
> patch which fixes all the race conditions in LSM removal *without*  

LSM is an infrastructure.  It's up to the modules to provide that, and
it can be done.  DTE used to do it.  Dirjail used to do it.  Capability
does it.

And since LSM won't be modular anymore it doesn't matter.

> adding much extra overhead.  I'm sure if your solutions works then  
> everyone will be much more open to modular LSMs.  I said this before:

Another blatant lie, not unlike "come to the table to upstream your LSM,
and we'll help you, honest."

(The funny thing about that is, I actually like SELinux, more than the
alternatives in general.  I just can't stand the attitudes voice by much
of its camp.)

-serge

PS - should we rename 'LSM' to 'LSI' - linux security infrastructure?
Calling it LSM now is kind of moronic.
