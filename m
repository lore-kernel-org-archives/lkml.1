Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYCLQrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYCLQrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 12:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYCLQrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 12:47:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:59582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYCLQrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 12:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=qhZj2qN5/zEpNxWVkalg2rrtvVRGr50bfi1XmKmcEKGlilt8vcr6haRM0obBMEsCmP93ItK1BCgbTOJg3PnR6aT8ZobJliA5igO3MlCmTrhyvTmr5c+ysAO8osVurw8YNXYG4LCHq/SzkneK+yxNSiGyH66dn5InSKAaUoPItQs=
Date: Wed, 12 Mar 2008 18:43:58 +0200
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: casey@schaufler-ca.com, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Audit-ML <linux-audit@redhat.com>, Steve Grubb <sgrubb@redhat.com>
Subject: Re: [RFC][PATCH -v2] Smack: Integrate with Audit
Message-ID: <20080312164358.GA9540@ubuntu>
References: <746579.84816.qm@web36612.mail.mud.yahoo.com> <1205336897.23866.296.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1205336897.23866.296.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 11:48:17AM -0400, Stephen Smalley wrote:
> 
> On Wed, 2008-03-12 at 08:40 -0700, Casey Schaufler wrote:
> > --- Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > 
> > > 
> > > On Wed, 2008-03-12 at 04:44 +0200, Ahmed S. Darwish wrote:
> > > > Hi!,
> > > > 
> > > > Setup the new Audit hooks for Smack. The AUDIT_SUBJ_USER and 
> > > > AUDIT_OBJ_USER SELinux flags are recycled to avoid `auditd' 
> > > > userspace modifications. Smack only needs auditing on 
> > > > a subject/object bases, so those flags were enough.
> > > 
> > > Only question I have is whether audit folks are ok with reuse of the
> > > flags in this manner, and whether the _USER flag is best suited for this
> > > purpose if you are going to reuse an existing flag (since Smack label
> > > seems more like a SELinux type than a SELinux user).
> > 
> > To-mate-o toe-maht-o.
> > 
> > There really doesn't seem to be any real reason to create a new
> > flag just because the granularity is different. The choice between
> > _USER and _TYPE (and _ROLE for that matter) is arbitrary from a
> > functional point of view. I say that since Smack has users, but
> > not types or roles, _USER makes the most sense.
> 
> Perhaps I misunderstand, but Smack labels don't represent users (i.e.
> user identity) in any way, so it seemed like a mismatch to use the _USER
> flag there.  Whereas types in SELinux bear some similarity to Smack
> labels - simple unstructured names whose meaning is only defined by the
> policy rules.
> 

I think Casey meant the common use of Smack where a login program
(openssh, bin/login, ..) sets a label for each user that logs in, thus
letting each label effectively representing a user.

In a sense, smack labels share a bit of _USER and _TYPE.

> Regardless, it seems like the audit maintainers ought to weigh in on the
> matter.
> 

Indeed.

Regards,

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

