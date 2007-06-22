Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbXFVAiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbXFVAiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 20:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbXFVAiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 20:38:15 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:11199 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbXFVAiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 20:38:14 -0400
Date: Thu, 21 Jun 2007 20:34:36 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Lars Marowsky-Bree <lmb@suse.de>, James Morris <jmorris@namei.org>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070622003436.GB6222@think.oraclecorp.com>
References: <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 04:59:54PM -0400, Stephen Smalley wrote:
> On Thu, 2007-06-21 at 21:54 +0200, Lars Marowsky-Bree wrote:
> > On 2007-06-21T15:42:28, James Morris <jmorris@namei.org> wrote:
> > 
> > > > A veto is not a technical argument. All technical arguments (except for
> > > > "path name is ugly, yuk yuk!") have been addressed, have they not?
> > > AppArmor doesn't actually provide confinement, because it only operates on 
> > > filesystem objects.
> > > 
> > > What you define in AppArmor policy does _not_ reflect the actual 
> > > confinement properties of the policy.  Applications can simply use other 
> > > mechanisms to access objects, and the policy is effectively meaningless.
> > 
> > Only if they have access to another process which provides them with
> > that data.
> 
> Or can access the data under a different path to which their profile
> does give them access, whether in its final destination or in some
> temporary file processed along the way.
> 
> > And now, yes, I know AA doesn't mediate IPC or networking (yet), but
> > that's a missing feature, not broken by design.
> 
> The incomplete mediation flows from the design, since the pathname-based
> mediation doesn't generalize to cover all objects unlike label- or
> attribute-based mediation.  And the "use the natural abstraction for
> each object type" approach likewise doesn't yield any general model or
> anything that you can analyze systematically for data flow.

This feels quite a lot like a repeat of the discussion at the kernel
summit.  There are valid uses for path based security, and if they don't
fit your needs, please don't use them.  But, path based semantics alone
are not a valid reason to shut out AA.

-chris

