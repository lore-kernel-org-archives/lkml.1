Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZC3Ez5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZC3Ez5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 00:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbZC3Ezd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 00:55:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:60502 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZC3Ezb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 00:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VHkXbGs4O7peKLdBurS8edpqRJVEDSQyLvy0SA2M7Ri7+nWy7gMrCZCHRKrngN2ZZ1
         a6nhOc0WzJ+MgpOBuGLqoIRrCODOrYqSGr4sm9Shd7ipspKF3Fj6JvRUZHhGoaDw5pcd
         tV3zlntq+02WRPZ5fJCj0ObAor593yY/DT5MU=
MIME-Version: 1.0
In-Reply-To: <9b1675090903292018g5e1d20f5yfd76286182cb2276@mail.gmail.com>
References: <9b1675090903291904g7eca965eydb1aa3f852a1b91c@mail.gmail.com>
	 <000301c9b0e1$af531e40$0df95ac0$@com>
	 <9b1675090903291954j26e2380fy74338490343eaa2@mail.gmail.com>
	 <897274600903292015n44005d12l82b0fafd170d6292@mail.gmail.com>
	 <9b1675090903292018g5e1d20f5yfd76286182cb2276@mail.gmail.com>
Date: Sun, 29 Mar 2009 22:55:28 -0600
Message-ID: <9b1675090903292155q6d221da1q6d19b7bca9cbe4e6@mail.gmail.com>
Subject: Re: 2.6.29 on MacBook 2,1 fails to reboot
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: "Morten P.D. Stevens" <mstevens@win-professional.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 9:18 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> I recall it working on 2.6.28, but i didn't have vanilla sources
> installed.  I used 2.6.28 gentoo sources.  I'm just compiling 2.6.28
> as we speak, as I figured you'd ask.  I've marked 2.6.29 as bad with
> "git bisect".  I'll let you know when I've narrowed it down for you.
> Can't wait to try "git bisect" *big smile*.

Yep, works fine on 2.6.28.  On 2.6.29, it does not unmount drives and
such.  I may not be able to finish with git bisect today, as I have to
work in the morning.  But, I'll try and wrap it up tomorrow if
possible.

Git reports so far...
tdamac linux # git bisect bad
Bisecting: 744 revisions left to test after this
[bb26c6c29b7cc9f39e491b074b09f3c284738d36] Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6

tdamac linux # git bisect log
git bisect start
# bad: [8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84] Linux 2.6.29
git bisect bad 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84
# good: [4a6908a3a050aacc9c3a2f36b276b46c0629ad91] Linux 2.6.28
git bisect good 4a6908a3a050aacc9c3a2f36b276b46c0629ad91
# bad: [2774de17ba65130165a2cbca92e5a685581f7916] Staging: benet:
build is broken unless CONFIG_NETPOLL is enabled
git bisect bad 2774de17ba65130165a2cbca92e5a685581f7916
# bad: [ba744d5e290055d171c68067259fcc1e2721f542] block: reorder
struct bio to remove padding on 64bit
git bisect bad ba744d5e290055d171c68067259fcc1e2721f542
# bad: [54a696bd07c14d3b1192d03ce7269bc59b45209a] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6
git bisect bad 54a696bd07c14d3b1192d03ce7269bc59b45209a
