Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZB1TZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZB1TZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 14:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbZB1TZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 14:25:21 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44047 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbZB1TZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 14:25:20 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49A98F93.5030206@s5r6.in-berlin.de>
Date: Sat, 28 Feb 2009 20:25:07 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk> <49A942F6.3020600@s5r6.in-berlin.de> <20090228155841.GA15127@sirena.org.uk> <49A962F8.30609@s5r6.in-berlin.de> <20090228164627.GC15127@sirena.org.uk> <49A97563.6040906@s5r6.in-berlin.de> <20090228175218.GA4606@sirena.org.uk>
In-Reply-To: <20090228175218.GA4606@sirena.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
[some people disregard the patch title in the Subject header]
> I believe the issue is the UI of a MUA - the subject line of a mail is
> normally presented separately to the body and isn't always as
> immediately prominent as the body so it's harder work to look at it.

That's not universally true for all MUA; and in affected MUAs only if
mails are read one-after-another, not if mails are read by looking at
the list of messages in a mailbox first, then going to the interesting
messages.  So if there are people who disregard the patch title for this
reason, then I dare to say it is because their view is limited by their
particular MUA and their individual mail reading preferences.  Their
preferences still don't make the convention go away that the Subject is
the title.  (And that the title should be a quick intro into what the
patch is about.)

> This is sensible for e-mail since the general style is that the subject
> line shouldn't be required in order to comprehend what the message is
> about

No.  The subject is the primary means to establish context for the
message (along with the mailinglist topic).  We ask people to post with
a good subject.

And since the subject already established context, there is no need to
repeat its information in the e-mail body.

> The connection with git is that it doesn't really draw a similar
> distinction so the issue isn't as immediately obvious when you're
> working within it. 

It isn't just a non-obvious issue with git, it is *no issue* with git in
the first place.  It also is no issue with other patch importing tools
like quilt.  All those tools either explicitly or implicitly support the
notion that the RFC 2822 Subject header contains the patch title.  They
support it because the *people* who use those tools support it.

Since "Subject = title = beginning of changelog" is the long established
norm and since the other patch handling tools (and people who handle
patches) support this norm, checkpatch should follow this convention as
well and count a non-empty RFC 2822 Subject header as one non-empty
changelog line.
-- 
Stefan Richter
-=====-==--= --=- ===--
http://arcgraph.de/sr/
