Return-Path: <linux-kernel-owner+w=401wt.eu-S1762544AbYCGU5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762544AbYCGU5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbYCGU5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:57:43 -0500
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:43891 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758271AbYCGU5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:57:43 -0500
X-YMail-OSG: .4Y972sVM1m1gFxjnEBZc9qfA6D3Xg2PlBWTrt1E1EVgYIjp
X-RocketYMMF: rancidfat
Date: Fri, 7 Mar 2008 12:57:42 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
To: Stephen Smalley <sds@tycho.nsa.gov>, "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>, Greg KH <greg@kroah.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       menage@google.com, sukadev@us.ibm.com
In-Reply-To: <1204919172.1397.541.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <26315.23145.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Stephen Smalley <sds@tycho.nsa.gov> wrote:

> 
> On Fri, 2008-03-07 at 12:30 -0600, Serge E. Hallyn wrote:
> > Quoting Casey Schaufler (casey@schaufler-ca.com):
> > > 
> > > --- "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> > > 
> > > > ...
> > > > 
> > > > Until user namespaces are complete, selinux seems the only good
> solution
> > > > to offer isolation.
> > > 
> > > Smack does it better and cheaper. (Unless you define good==selinux)
> > > (insert smiley)
> > 
> > Ah, thanks - I hadn't looked into it, but yes IIUC smack should
> > definately work.  I'll have to give that a shot.
> 
> Not if you want to confine uid 0.  smack doesn't control capabilities,
> even the ones used to override it.
> 
> So you'd have to at least configure your per-process bset and file caps
> rather carefully.  And even then you have to watch out for things with
> CAP_MAC* or CAP_SETPCAP.

Shrug. As if getting 800,000 lines of policy definition
for a thousand applications completely correct is going to be easier.


Casey Schaufler
casey@schaufler-ca.com
