Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZB1Qqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZB1Qqu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 11:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZB1Qqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 11:46:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:3870 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZB1Qqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 11:46:38 -0500
Date: Sat, 28 Feb 2009 16:46:29 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Message-ID: <20090228164627.GC15127@sirena.org.uk>
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk> <49A942F6.3020600@s5r6.in-berlin.de> <20090228155841.GA15127@sirena.org.uk> <49A962F8.30609@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A962F8.30609@s5r6.in-berlin.de>
X-Cookie: You will pass away very quickly.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 05:14:48PM +0100, Stefan Richter wrote:
> Mark Brown wrote:

> > That's not a false postive, that's exactly the case it's intended to
> > catch.

> It *is* a false positive if a single-line changelog is entirely
> sufficient.  (There are many patches whose changelogs can and should be
> a single line, plus sign-offs.)

No, really.  People are literally saying that no changelog in the body
of the e-mail is a problem for them.  Since if (like me) you use git
there's nothing in the toolchain that suggests that a changelog might
not have been written it seemed best to add something to generate a
warning.

> > People like Andrew Morton complain because there's no text in
> > the actual body of the email (as well as because some of the patches
> > that do this could probably use a bit more explanation).

> Well, I haven't closely watched akpm's complaints, but I'm sure he
> doesn't complain about too few lines changelog, he complains about
> insufficient information in the changelog.

No, people (not just Andrew) really are complaining about a simple lack
of any text in the body of the mail.  The term "unchangedlogged" has
been specifically used here.  It is apparent that they do not consider
the subject line of the e-mail (which is the first line of the changelog
if you're using git) to be part of the changelog.

> Your checkpatch modification does not check for insufficient information
> in the changelog.  It only checks line count.

Well, yes.  The intention is purely to detect if there is a body in the
changelog.
