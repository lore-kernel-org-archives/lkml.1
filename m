Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbYB2CIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbYB2CIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYB2CH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:07:56 -0500
Received: from web36609.mail.mud.yahoo.com ([209.191.85.26]:40974 "HELO
	web36609.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751803AbYB2CHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:07:55 -0500
X-YMail-OSG: KvJ4UNYVM1kHX5dxJcHLFwEexW5.OReEzOeOITqEml4wRKuUgPve6eJyHlUyAEXclx5_SQVMsA--
X-RocketYMMF: rancidfat
Date: Thu, 28 Feb 2008 18:07:53 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Dave Quigley <dpquigl@tycho.nsa.gov>,
       Christoph Hellwig <hch@infradead.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, casey@schaufler-ca.com,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204245767.2715.43.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <147227.75672.qm@web36609.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Dave Quigley <dpquigl@tycho.nsa.gov> wrote:

> 
> On Thu, 2008-02-28 at 20:00 -0500, Christoph Hellwig wrote:
> > On Thu, Feb 28, 2008 at 07:32:47PM -0500, Dave Quigley wrote:
> > > I can always go with the original hook name of get_security_xattr_name
> > > which turns into a security_get_security_xattr_name call which seems a
> > > bit ludicrous. The only other complaint that I saw from Casey besides
> > > the name of the function was that there could be more than one xattr. If
> > > we want to address that then I need another hook that says give me all
> > > data that the LSM deems important for this file. Which is essentially
> > > the same thing as taking each of the xattr names that the module will
> > > provide, grabbing each of them in turn, and concatenating them together.
> > > For SELinux this is no different than getsecurity with the selinux
> > > suffix. The same goes for SMACK.
> > 
> > What about Casey's suggestion of get_security_blob?  For any reasonable
> > module that just has a single xattr it's trivial and for those that
> > have multiple or a different storage model it might get complicated
> > but that's not our problem for now.
> 
> If this is the method we are going to use then we need a corresponding
> set_security_blob as well.

Not to sound stupid, but why would you need this?

> This seems like a paradigm shift for
> accessing security information in the kernel.

Well, yes, but look at David Howell's file cacheing work
before you take too firm a stand.

> I said to Casey in the
> beginning that I'd be willing to revisit it but that neither he or I
> alone could make the decision. Unless I misunderstood the original
> mandate for security information and that it only applies to how user
> space accesses it.

Sorry, I don't understand how user space and mandates go together here.


Casey Schaufler
casey@schaufler-ca.com
