Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbZCBTTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbZCBTTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 14:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZCBTTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 14:19:47 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2891 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbZCBTTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 14:19:46 -0500
Date: Mon, 2 Mar 2009 19:19:11 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Theodore Tso <tytso@mit.edu>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-ID: <20090302191910.GG19744@sirena.org.uk>
References: <20090228210223.GA23191@sirena.org.uk> <49A9C252.50204@s5r6.in-berlin.de> <20090301001829.GA10751@mit.edu> <20090301004618.GA12909@sirena.org.uk> <20090301025357.GC10751@mit.edu> <20090302131514.GC19744@sirena.org.uk> <49ABF825.1010501@s5r6.in-berlin.de> <20090302100158.bb83bec6.akpm@linux-foundation.org> <20090302182456.GF19744@sirena.org.uk> <20090302103437.f3109332.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302103437.f3109332.akpm@linux-foundation.org>
X-Cookie: What hath Bob wrought?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 10:34:37AM -0800, Andrew Morton wrote:

> The reason I asked you personally to always send a changelog is because
> I quite frequently sit there scratching my head at your patches not
> having a clue what they do nor how to prioritise them.

Hrm.  Are you by any chance referring to the changelog as being *only*
the bit in the body of the e-mail?  If so that's half the confusion here
- in tools such as git the changelog also includes what ends up in the
subject of the e-mail.  This is what I was reading your comments (to
others as well, I wouldn't have bothered if it had just been me) as
referring to.

I'm not sure that simply supplying a body would help anything here, FWIW
- if I'm writing a body for the sake of it it'll generally just be
repetitive which isn't terribly constructive.  Obviously I do *try* to
write sensible changelogs and will keep making an effort to do so.  As
far as I remember most of the issues in the past have been due to
missing out something along the lines of "...because that's what the
silicon does" but ICBW.

As far as prioritisation goes I'd always expect to have to explicitly
call out anything other than merging via -next with no particular
urgency.
