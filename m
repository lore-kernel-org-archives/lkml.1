Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbXFOVnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbXFOVnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXFOVnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:43:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40415 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbXFOVnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:43:00 -0400
Date: Fri, 15 Jun 2007 14:44:41 -0700
From: Greg KH <greg@kroah.com>
To: Karl MacMillan <kmacmill@redhat.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
Message-ID: <20070615214441.GB18039@kroah.com>
References: <1181931330.17547.866.camel@moss-spartans.epoch.ncsc.mil> <44036.5340.qm@web36611.mail.mud.yahoo.com> <20070615211414.GC7337@kroah.com> <1181942915.9809.35.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181942915.9809.35.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 05:28:35PM -0400, Karl MacMillan wrote:
> On Fri, 2007-06-15 at 14:14 -0700, Greg KH wrote:
> > On Fri, Jun 15, 2007 at 01:43:31PM -0700, Casey Schaufler wrote:
> > > 
> > > Yup, I see that once you accept the notion that it is OK for a
> > > file to be misslabeled for a bit and that having a fixxerupperd
> > > is sufficient it all falls out.
> > > 
> > > My point is that there is a segment of the security community
> > > that had not found this acceptable, even under the conditions
> > > outlined. If it meets your needs, I say run with it.
> > 
> > If that segment feels that way, then I imagine AA would not meet their
> > requirements today due to file handles and other ways of passing around
> > open files, right?
> > 
> > So, would SELinux today (without this AA-like daemon) fit the
> > requirements of this segment?
> > 
> 
> Yes - RHEL 5 is going through CC evaluations for LSPP, CAPP, and RBAC
> using the features of SELinux where appropriate.

Great, but is there the requirement in the CC stuff such that this type
of "delayed re-label" that an AA-like daemon would need to do cause that
model to not be able to be certified like your SELinux implementation
is?

As I'm guessing the default "label" for things like this already work
properly for SELinux, I figure we should be safe, but I don't know those
requirements at all.

thanks,

greg k-h
