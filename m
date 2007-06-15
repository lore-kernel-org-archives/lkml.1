Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbXFOWh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbXFOWh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 18:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbXFOWhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 18:37:50 -0400
Received: from web36612.mail.mud.yahoo.com ([209.191.85.29]:47517 "HELO
	web36612.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751015AbXFOWht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 18:37:49 -0400
X-YMail-OSG: H8YVrV0VM1ls0r_Lz8d0_C87E1jBbTjVwwzXyMGy0rtWxqmQMD3ETLAQgfHOFrrWDg--
X-RocketYMMF: rancidfat
Date: Fri, 15 Jun 2007 15:37:48 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
To: Greg KH <greg@kroah.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Crispin Cowan <crispin@novell.com>,
       Andreas Gruenbacher <agruen@suse.de>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20070615211414.GC7337@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <539355.82720.qm@web36612.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Greg KH <greg@kroah.com> wrote:

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

That segment is itself divided (think the "Judean Peoples Front"
and the "Peoples Front of Judea") on many issues, but as it has
always put correctness over ease of use I would expect AppArmor to
have a tough roe to hoe. There are other segments for which AppArmor
may well be appealing, and those segments have always been much
larger than Judea.

> So, would SELinux today (without this AA-like daemon) fit the
> requirements of this segment?

The JPF is head over heels in love with SELinux, restorecond and all.
The PFJ has some issues, but will most likely go along with the JPF
in part because the JPF is bringing the beer and besides, what are
their alternatives today? The PJF ("that's him, over there") is still
stunned by some of what SELinux accepts as normal (restorecond, 400,000
line "policy" definitions with embedded wildcards) and spends a lot
of time chanting the TCB Principle in hopes that it will help, but
no lightning strikes from above to date.

But you knew that. I'm an advocate of making a variety of alternates
available which is why I had originally proposed the authoritative
hooks version of the LSM and why I don't believe in rolling every
possible security facility into SELinux. I also believe in warning
people of pitfalls before they've impaled themselves on the spikes,
but some people gotta have the experience. Just trying to help.


Casey Schaufler
casey@schaufler-ca.com
