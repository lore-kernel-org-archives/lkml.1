Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZB1VCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZB1VCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 16:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZB1VCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 16:02:35 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3063 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbZB1VCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 16:02:34 -0500
Date: Sat, 28 Feb 2009 21:02:24 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Message-ID: <20090228210223.GA23191@sirena.org.uk>
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk> <49A942F6.3020600@s5r6.in-berlin.de> <20090228155841.GA15127@sirena.org.uk> <49A962F8.30609@s5r6.in-berlin.de> <20090228164627.GC15127@sirena.org.uk> <49A97563.6040906@s5r6.in-berlin.de> <20090228175218.GA4606@sirena.org.uk> <49A98F93.5030206@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A98F93.5030206@s5r6.in-berlin.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 08:25:07PM +0100, Stefan Richter wrote:

> messages.  So if there are people who disregard the patch title for this
> reason, then I dare to say it is because their view is limited by their
> particular MUA and their individual mail reading preferences.  Their

Look, I pretty much agree.  Personally I don't find this a problem.

> > The connection with git is that it doesn't really draw a similar
> > distinction so the issue isn't as immediately obvious when you're
> > working within it. 

> It isn't just a non-obvious issue with git, it is *no issue* with git in
> the first place.  It also is no issue with other patch importing tools

Well, exactly.  There is no issue within git so it's not obvious that
people are going to have a problem when you're working in git.

> Since "Subject = title = beginning of changelog" is the long established
> norm and since the other patch handling tools (and people who handle
> patches) support this norm, checkpatch should follow this convention as
> well and count a non-empty RFC 2822 Subject header as one non-empty
> changelog line.

As I have previously said, that is not the case in reality.  There
appears to be substantial sentiment among people handling patches that
not having any text in the body of the e-mail makes it harder to handle
patches.  I don't have that issue myself but I understand it and it
seems easier to write longer changelogs than to try to change everyone's
workflows.  Quite a few of the one line changelogs could probably
benefit from being expanded a little anyway.
