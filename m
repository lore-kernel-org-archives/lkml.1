Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZB1Rwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZB1Rwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZB1Rw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:52:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1924 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZB1Rw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:52:28 -0500
Date: Sat, 28 Feb 2009 17:52:20 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Message-ID: <20090228175218.GA4606@sirena.org.uk>
References: <1235757920-20474-1-git-send-email-broonie@sirena.org.uk> <49A942F6.3020600@s5r6.in-berlin.de> <20090228155841.GA15127@sirena.org.uk> <49A962F8.30609@s5r6.in-berlin.de> <20090228164627.GC15127@sirena.org.uk> <49A97563.6040906@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A97563.6040906@s5r6.in-berlin.de>
X-Cookie: Are you sure the back door is locked?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 06:33:23PM +0100, Stefan Richter wrote:

> This really surprises me.  ^Subject: .+$ is the title of the log and
> thereby its first part.  Also, I don't see a connection to git.  I
> manage patches with quilt and never loose patch titles.  I still think
> you should count ^Subject: .+$ too if you want to check for presence of
> a changelog.

I believe the issue is the UI of a MUA - the subject line of a mail is
normally presented separately to the body and isn't always as
immediately prominent as the body so it's harder work to look at it.
This is sensible for e-mail since the general style is that the subject
line shouldn't be required in order to comprehend what the message is
about but that's exactly what's happening when a one line changelog is
e-mailed.

The connection with git is that it doesn't really draw a similar
distinction so the issue isn't as immediately obvious when you're
working within it. 
