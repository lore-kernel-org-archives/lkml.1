Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbXLIGUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbXLIGUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 01:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbXLIGUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 01:20:13 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:41266 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750702AbXLIGUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 01:20:11 -0500
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: Pardus / KDE
To: Theodore Tso <tytso@mit.edu>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Date: Sun, 9 Dec 2007 08:21:16 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Adrian Bunk <bunk@kernel.org>, Bill Davidsen <davidsen@tmr.com>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
References: <20071204114125.GA17310@torres.zugschlus.de> <200712090010.10362.ismail@pardus.org.tr> <20071208234612.GQ17037@thunk.org>
In-Reply-To: <20071208234612.GQ17037@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712090821.16483.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday 09 December 2007 01:46:12 tarihinde Theodore Tso şunları yazmıştı:
> On Sun, Dec 09, 2007 at 12:10:10AM +0200, Ismail Dönmez wrote:
> > > As long as /dev/random is readable for all users there's no reason to
> > > use /dev/urandom for a local DoS...
> >
> > Draining entropy in /dev/urandom means that insecure and possibly not
> > random data will be used and well thats a security bug if not a DoS bug.
>
> Actually in modern 2.6 kernels there are two separate output entropy
> pools for /dev/random and /dev/urandom.  So assuming that the
> adversary doesn't know the contents of the current state of the
> entropy pool (i.e., the RNG is well seeded with entropy), you can read
> all you want from /dev/urandom and that won't give an adversary
> successful information to attack /dev/random.

My understanding was if you can drain entropy from /dev/urandom any futher 
reads from /dev/urandom will result in data which is not random at all. Is 
that wrong?

Regards,
ismail

-- 
Never learn by your mistakes, if you do you may never dare to try again.
