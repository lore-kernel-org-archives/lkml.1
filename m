Return-Path: <linux-kernel-owner+w=401wt.eu-S1766893AbXDSR2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766893AbXDSR2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 13:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766891AbXDSR2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 13:28:32 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:43811 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161510AbXDSR2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 13:28:30 -0400
Subject: Re: AppArmor FAQ
From: Stephen Smalley <sds@tycho.nsa.gov>
To: David Lang <david.lang@digitalinsight.com>
Cc: James Morris <jmorris@namei.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>,
       Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.63.0704181311390.2806@qynat.qvtvafvgr.pbz>
References: <20070417181016.GA10903@one.firstfloor.org>
	 <657751.18080.qm@web3 6614.mail.mud.yahoo.com>
	 <20070417211653.GB11944@one.firstfloor.org>
	 <20070417225815.000b0fdb@the-vil lage.bc.nu>
	 <Line.LNX.4.64.0704180935100.25495@d.namei>
	 <Pine.LNX.4.63.0704181311390.2806@qynat.qvtvafvgr.pbz>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 19 Apr 2007 13:27:51 -0400
Message-Id: <1177003671.27654.133.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-18 at 13:15 -0700, David Lang wrote:
> On Wed, 18 Apr 2007, James Morris wrote:
> 
> > On Tue, 17 Apr 2007, Alan Cox wrote:
> >
> >> I'm not sure if AppArmor can be made good security for the general case,
> >> but it is a model that works in the limited http environment
> >> (eg .htaccess) and is something people can play with and hack on and may
> >> be possible to configure to be very secure.
> >
> > Perhaps -- until your httpd is compromised via a buffer overflow or
> > simply misbehaves due to a software or configuration flaw, then the
> > assumptions being made about its use of pathnames and their security
> > properties are out the window.
> 
> since AA defines a whitelist of files that httpd is allowed to access, a 
> comprimised one may be able to mess up it's files, but it's still not going to 
> be able to touch other files on the system.
> 
> > Without security labeling of the objects being accessed, you can't protect
> > against software flaws, which has been a pretty fundamental and widely
> > understood requirement in general computing for at least a decade.
> 
> this is not true. you don't need to label all object and chunks of memory, you 
> just need to have a way to list (and enforce) the objects and memory that the 
> program is allowed to use. labeling them is one way of doing this, but not the 
> only way.

You need a way of providing global and persistent security guarantees
for the data, and per-program profiles based on pathname don't get you
there.  There is no system view in AA, just a bunch of disconnected
profiles.

-- 
Stephen Smalley
National Security Agency

