Return-Path: <linux-kernel-owner+w=401wt.eu-S1760951AbXFRBvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951AbXFRBvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 21:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbXFRBvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 21:51:31 -0400
Received: from web36601.mail.mud.yahoo.com ([209.191.85.18]:21081 "HELO
	web36601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756441AbXFRBva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 21:51:30 -0400
X-YMail-OSG: O0ltwV4VM1nTyMo79BUEi.HgGmyJtz7gkdxoHmbb4bCl2G94vxmlDQJMyR_.EJigAOFtkqqHxQ--
X-RocketYMMF: rancidfat
Date: Sun, 17 Jun 2007 18:51:29 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
To: James Morris <jmorris@namei.org>, Casey Schaufler <casey@schaufler-ca.com>
Cc: Greg KH <greg@kroah.com>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <Line.LNX.4.64.0706152334570.30443@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <822529.74206.qm@web36601.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- James Morris <jmorris@namei.org> wrote:

> On Fri, 15 Jun 2007, Casey Schaufler wrote:
> 
> > 
> > --- James Morris <jmorris@namei.org> wrote:
> > 
> > > On my system, it takes about 1.2 seconds to label a fully checked out 
> > > kernel source tree with ~23,000 files in this manner
> > 
> > That's an eternity for that many files to be improperly labeled.
> > If, and the "if" didn't originate with me, your policy is
> > demonstrably correct (how do you do that?) for all domains
> > you could claim that the action is safe, if not ideal. 
> > I can't say if an evaluation team would buy the "safe"
> > argument. They've been known to balk before.
> 
> To clarify:
> 
> We are discussing a scheme where the underlying SELinux labeling policy 
> always ensures a safe label on a file, and then relabeling newly created 
> files according to their pathnames.

To counter clarify:

You are saying two things:
1. The policy always ensures a safe label.
2. Files can be relabeled in a reasonable and timely manner.

I have no questions about 2. It's a hack, but you've already
acknowledged that and it will work, allowing for some potential
cases where someone is overeager about getting a file-in-transition.

Regarding 1: This is a founding premise of the arguement, that
the "policy" is written correctly such that there is no case
where a file gets created with an unsafe label. Given the external
nature of the policy, and the number of attributes used within
the policy, and the overall sophistication of the policy mechanism,
how does one ...

    a. know that a label is "safe"
    b. know that a file will get a "safe" label
    c. know that the policy is "correctly" written as required

The question is not if fixxerupperd can set things right.
The question is about the properly written policy that is
required to make the mechanism worth discussing.

> There is no expectation that this scheme would be submitted for 
> certification.

De-nial.

> Its purpose is to merely to provide pathname-based 
> labeling outside of the kernel.

If you already have an in-kernel labeling scheme that you
trust to make the world safe until you get around to doing
the labeling externally you can argue that it's good enough.
But, to quote Cinderella's Stepmother, "I said "if"".


Casey Schaufler
casey@schaufler-ca.com
