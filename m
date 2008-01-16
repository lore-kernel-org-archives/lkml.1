Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbYAPRI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbYAPRI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYAPRIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:08:18 -0500
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:21034 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752490AbYAPRIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:08:17 -0500
X-YMail-OSG: n0GKImIVM1m0GMUbI7KsteReQnF53nQQ3ABtN55IZj32mU1SIPoj74YJsYi15f.6mAy1BuE8mg--
X-RocketYMMF: rancidfat
Date: Wed, 16 Jan 2008 09:08:16 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/26] Add a secctx_to_secid() LSM hook to go along with the existing
To: Paul Moore <paul.moore@hp.com>, James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov,
       casey@schaufler-ca.com, Trond.Myklebust@netapp.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <200801160841.46633.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <229068.55387.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Paul Moore <paul.moore@hp.com> wrote:

> On Tuesday 15 January 2008 8:05:27 pm James Morris wrote:
> > On Tue, 15 Jan 2008, David Howells wrote:
> > > secid_to_secctx() LSM hook.  This patch also includes the SELinux
> > > implementation for this hook.
> > >
> > > Signed-off-by: Paul Moore <paul.moore@hp.com>
> > > Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> >
> > This is useful in its own right, and I would like to push it upstream for
> > 2.6.24 unless there are any objections.
> 
> Isn't it a bit late in 2.6.24 to add new functionality, especially when there
> 
> isn't an in-tree user for it in 2.6.24?
> 
> You are right, there are several users of this function currently under 
> development but I'm pretty sure all of them are targeting 2.6.25 or greater. 
> 
> With that in mind, I think the prudent thing to is to wait and push this 
> upstream for 2.6.25.

I concur with Paul. I had to delete the message I was composing because
it said exactly the same thing.

I do think that we need to put some thought into what a secid
really is and what a secctx ought to look like what with multiple
user cropping up for them. To date audit is the only out-of-LSM
user of the secctx, and assumes it's a printable text string, but
if cacheing is going to be using it as well we're approaching the
secctx being a "general" interface, and hence a part of the LSM
proper. Probably makes sense to include something in the LSM
documentation. With luck, someone who spells better than I will
beat me to it, but such an update is on my todo list.




Casey Schaufler
casey@schaufler-ca.com
