Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYAJNmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYAJNmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 08:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbYAJNmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 08:42:35 -0500
Received: from mail.cs.tut.fi ([130.230.4.42]:49427 "EHLO mail.cs.tut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbYAJNme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 08:42:34 -0500
Date: Thu, 10 Jan 2008 15:41:11 +0200
From: Tuomo Valkonen <tuomov@iki.fi>
To: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080110134111.GA6254@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <18307.42821.166376.732473@stoffel.org> <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi> <871w8r6ruc.fsf@barad-dur.regala.cx> <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi> <20080110131659.GF10230@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080110131659.GF10230@mit.edu>
X-Archive: encrypt
X-PGP-Fingerprint: 3B2A 89E6 9468 6DC4 FEEF  D6F6 D00C A21E C004 251B
X-PGP-Key: http://modeemi.fi/~tuomov/gpg.txt.asc
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-10 08:16 -0500, Theodore Tso wrote:
> > It displays just the right time. On boot anyway. (Linux has had some
> > serious problems keeping the time after the switch from 2.6.7 to 2.6.14,
> > advanding even 15 minutes a day -- that ntpd doesn't seem to be able 
> > to keep up with -- requiring running adjtimexconfig every now and
> > then for new settings. But the cmos clock displays the right time.)
> 
> What do you mean by "on boot"?  Which boot message, precisely?  Is the
> time printed before or after e2fsck is run, and by which program?

The time is right as displayed by `date` after boot, i.e. after it has
been loaded from the CMOS clock that does keep the (local, IIRC) time
just allright. But then it often starts advancing very fast.

-- 
Tuomo
