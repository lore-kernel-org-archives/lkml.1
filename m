Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbXFOV3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbXFOV3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbXFOV2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:28:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbXFOV2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:28:52 -0400
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
From: Karl MacMillan <kmacmill@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20070615211414.GC7337@kroah.com>
References: <1181931330.17547.866.camel@moss-spartans.epoch.ncsc.mil>
	 <44036.5340.qm@web36611.mail.mud.yahoo.com>
	 <20070615211414.GC7337@kroah.com>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 15 Jun 2007 17:28:35 -0400
Message-Id: <1181942915.9809.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.3 (2.11.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 14:14 -0700, Greg KH wrote:
> On Fri, Jun 15, 2007 at 01:43:31PM -0700, Casey Schaufler wrote:
> > 
> > Yup, I see that once you accept the notion that it is OK for a
> > file to be misslabeled for a bit and that having a fixxerupperd
> > is sufficient it all falls out.
> > 
> > My point is that there is a segment of the security community
> > that had not found this acceptable, even under the conditions
> > outlined. If it meets your needs, I say run with it.
> 
> If that segment feels that way, then I imagine AA would not meet their
> requirements today due to file handles and other ways of passing around
> open files, right?
> 
> So, would SELinux today (without this AA-like daemon) fit the
> requirements of this segment?
> 

Yes - RHEL 5 is going through CC evaluations for LSPP, CAPP, and RBAC
using the features of SELinux where appropriate.

Karl



