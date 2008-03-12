Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYCLSJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYCLSJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751587AbYCLSJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:09:44 -0400
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:40383 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751381AbYCLSJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:09:43 -0400
X-YMail-OSG: Z9.1NJMVM1l7qksFDWjNICIJONzQ5i93G0bm5m411nSk0jWTDq03Hg6ix1GkxyAggw--
X-RocketYMMF: rancidfat
Date: Wed, 12 Mar 2008 11:09:39 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [RFC][PATCH -v2] Smack: Integrate with Audit
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Cc: casey@schaufler-ca.com, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Audit-ML <linux-audit@redhat.com>, Steve Grubb <sgrubb@redhat.com>
In-Reply-To: <20080312164358.GA9540@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <423839.91626.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> 
> > Perhaps I misunderstand, but Smack labels don't represent users (i.e.
> > user identity) in any way, so it seemed like a mismatch to use the _USER
> > flag there.  Whereas types in SELinux bear some similarity to Smack
> > labels - simple unstructured names whose meaning is only defined by the
> > policy rules.
> > 
> 
> I think Casey meant the common use of Smack where a login program
> (openssh, bin/login, ..) sets a label for each user that logs in, thus
> letting each label effectively representing a user.

No, I really just don't care which name gets used because none
of them map properly but I don't see value in adding a new one.
I say _USER is fine. I dislike _TYPE because it implies structure
that isn't there and I dislike _ROLE because someone may want to
implement roles on top of Smack (it wouldn't be hard) and don't
want to start using that term for a specific meaning that might
give 'em fits.

> 
> In a sense, smack labels share a bit of _USER and _TYPE.

And maybe _ROLE, if you look at it from the right angle.
I don't think that it matters. Create a new _LATEFORDINNER
if that makes y'all feel better. Best of all would be to
stick with _USER and call it done.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
