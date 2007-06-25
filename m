Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbXFYEyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbXFYEyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbXFYEy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:54:29 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:38434 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753281AbXFYEy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:54:28 -0400
X-YMail-OSG: gQLkHwEVM1mFFHlo7AM_mJ7gRoQU.xNmPAn0.HSEVCEYXluARN9BzdIyyb..4t52zBrPYL0S_w--
Date: Sun, 24 Jun 2007 23:54:24 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
Message-ID: <20070625045424.GA9271@vino.hallyn.com>
References: <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com> <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com> <Line.LNX.4.64.0706241158320.12660@localhost.localdomain> <Line.LNX.4.64.0706241653490.14183@localhost.localdomain> <20070625035743.GA8786@vino.hallyn.com> <20070625041015.GG3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625041015.GG3723@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Wright (chrisw@sous-sol.org):
> * Serge E. Hallyn (serge@hallyn.com) wrote:
> > Sigh, as much as I would *like* to stay out of this (I don't
> > use modules at all on any system where I can avoid it), won't
> > it make development - and especially testing - of new lsms
> > much more painful and therefore less likely?
> 
> Dev, hopefully not.  Testing, well, perhaps.
> 
> > I realize there has been a dearth of new LSMs to date, but if
> > for instance a new solaris 10 based capability module were written,
> > well, people would want to be able to
> > 
> > 	rmmod capability
> > 	modprobe cap_prm
> 
> The problem is it's not necessarily even safe to do rmmod at all.
> And modprobe may require extra labelling, or extra checks for
> unlabelled objects (perhaps not so much for your example).

Right, and given that it's trivial for the author of an LSM which
shouldn't be modular to make the LSM a boolean config rather than
tristate, it doesn't seem like a good reason to take away the
ability to have LSM modules.

-serge
