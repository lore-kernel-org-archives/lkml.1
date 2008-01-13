Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYAMWN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYAMWN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 17:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbYAMWNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 17:13:49 -0500
Received: from mail.cs.tut.fi ([130.230.4.42]:60718 "EHLO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbYAMWNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 17:13:48 -0500
Date: Mon, 14 Jan 2008 00:13:01 +0200
From: Tuomo Valkonen <tuomov@iki.fi>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <18307.42821.166376.732473@stoffel.org> <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi> <871w8r6ruc.fsf@barad-dur.regala.cx> <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi> <20080110131659.GF10230@mit.edu> <20080110134111.GA6254@jolt.modeemi.cs.tut.fi> <20080112150621.GC6751@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080112150621.GC6751@mit.edu>
X-Archive: encrypt
X-PGP-Fingerprint: 3B2A 89E6 9468 6DC4 FEEF  D6F6 D00C A21E C004 251B
X-PGP-Key: http://modeemi.fi/~tuomov/gpg.txt.asc
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-12 10:06 -0500, Theodore Tso wrote:
> So running the "date" command after the boot sequence is completely
> finished.  That doesn't mean that system clock was correct at the time
> when fsck is run.  

Unless ntpd has managed to change it by that time, it was correct, 
in the local time zone. But judging from the "too big difference,
refusing to correct" behaviour of ntpd while the system is up,
I doubt ntpd would correct the time at boot, if it were considerably
wrong. This rapidly advancing system clock is A COMPLETELY DIFFERENT
PROBLEM that started with switch from 2.6.7 to 2.6.14. Before that
it worked just fine.

> Unfortunately Ubuntu users in Europe fit this
> demographic hugely, and Ubuntu refuses to fix this problem[1], so it's
> been personally very vexing, because the users complain to *me*, and I
> can't fix the problem, because it's a distribution init script issue.

FYI, I'm not running Ubuntu. This system once used to by Debian, 
but since Etch is already obsolete wrt. many non-base software, 
and I'm not going to suffer stable/unstable anymore, and megafrozen
megadistros with everything between the earth and skies suck anyway,
largely consists of self-installed software by now. Maybe they broke
time initialisations for etch.

Also, I must say that e2fsck is brain-damaged, if it can be confused 
by/do the stupid then when the system clock has warped by just a few
hours, not the _days_ that a file system check interval typically is,
and users need to specifically kludge around such misbehaviour in 
e2fsck.

-- 
Tuomo
