Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbXFYEKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbXFYEKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbXFYEKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:10:38 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:51550 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbXFYEKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:10:37 -0400
Date: Sun, 24 Jun 2007 21:10:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
Message-ID: <20070625041015.GG3723@sequoia.sous-sol.org>
References: <4676007F.7060503@kernel.org> <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com> <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com> <Line.LNX.4.64.0706241158320.12660@localhost.localdomain> <Line.LNX.4.64.0706241653490.14183@localhost.localdomain> <20070625035743.GA8786@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625035743.GA8786@vino.hallyn.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn (serge@hallyn.com) wrote:
> Sigh, as much as I would *like* to stay out of this (I don't
> use modules at all on any system where I can avoid it), won't
> it make development - and especially testing - of new lsms
> much more painful and therefore less likely?

Dev, hopefully not.  Testing, well, perhaps.

> I realize there has been a dearth of new LSMs to date, but if
> for instance a new solaris 10 based capability module were written,
> well, people would want to be able to
> 
> 	rmmod capability
> 	modprobe cap_prm

The problem is it's not necessarily even safe to do rmmod at all.
And modprobe may require extra labelling, or extra checks for
unlabelled objects (perhaps not so much for your example).

thanks,
-chris
