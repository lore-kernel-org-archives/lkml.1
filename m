Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZB1QPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZB1QPY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 11:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZB1QPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 11:15:09 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43220 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZB1QPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 11:15:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A962F8.30609@s5r6.in-berlin.de>
Date: Sat, 28 Feb 2009 17:14:48 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk> <49A942F6.3020600@s5r6.in-berlin.de> <20090228155841.GA15127@sirena.org.uk>
In-Reply-To: <20090228155841.GA15127@sirena.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Sat, Feb 28, 2009 at 02:58:14PM +0100, Stefan Richter wrote:
> 
>> This gives false positives for patches like this:
> 
>> From: [...]
>> Subject: this single line fully explains the whole patch
> 
>> Signed-off-by: [...]
> 
> That's not a false postive, that's exactly the case it's intended to
> catch.

It *is* a false positive if a single-line changelog is entirely
sufficient.  (There are many patches whose changelogs can and should be
a single line, plus sign-offs.)

You could as well

	if few_changelog_lines
		warn "You have written a short changelog."
		warn "Don't you want to write some more?"
		warn "(PS: I don't care what you write in particular"
		warn "as long as you just add more lines.)"

	if many_changelog_lines
		warn "You have written a long changelog."
		warn "Can't you express yourselves more concisely?"
		warn "(PS: I don't care what you'll omit in particular"
		warn "as long as you get the line count down.)"

> People like Andrew Morton complain because there's no text in
> the actual body of the email (as well as because some of the patches
> that do this could probably use a bit more explanation).

Well, I haven't closely watched akpm's complaints, but I'm sure he
doesn't complain about too few lines changelog, he complains about
insufficient information in the changelog.

Your checkpatch modification does not check for insufficient information
in the changelog.  It only checks line count.
-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/
