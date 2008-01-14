Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYANH0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYANH0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 02:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYANH0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 02:26:34 -0500
Received: from mail.cs.tut.fi ([130.230.4.42]:50235 "EHLO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYANH0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 02:26:33 -0500
Date: Mon, 14 Jan 2008 09:15:55 +0200
From: Tuomo Valkonen <tuomov@iki.fi>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
References: <18307.42821.166376.732473@stoffel.org> <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi> <871w8r6ruc.fsf@barad-dur.regala.cx> <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi> <20080110131659.GF10230@mit.edu> <20080110134111.GA6254@jolt.modeemi.cs.tut.fi> <20080112150621.GC6751@mit.edu> <20080113221301.GA18341@jolt.modeemi.cs.tut.fi> <20080113222310.GA20815@jolt.modeemi.cs.tut.fi> <20080113231150.GB23906@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080113231150.GB23906@mit.edu>
X-Archive: encrypt
X-PGP-Fingerprint: 3B2A 89E6 9468 6DC4 FEEF  D6F6 D00C A21E C004 251B
X-PGP-Key: http://modeemi.fi/~tuomov/gpg.txt.asc
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-13 18:11 -0500, Theodore Tso wrote:
> It's much more likely that this early in your boot cycle, your clock is
> sometimes incorrect.

I doubt it. I get this nearly _always_ when the system crashes, which
accounts for the vast majority of the times I boot it. (I wish swsusp
didn't suck so much..)

> Is the "9192" number roughly constant, or is it always changing?

No. That's the number I got last time, but typically I've got 
something in the 3xxxx range. 

> If your machine is on the network, then the "ntpdate"
> program could be setting your time so that it looks correct, but
> that's after e2fsck is run.  

ntpdate isn't run by any of the init scripts. ntpd is, but like I 
already mentioned, I doubt it would correct vastly incorrect time,
not even being able to track and correct when it advances fast.

-- 
Tuomo
