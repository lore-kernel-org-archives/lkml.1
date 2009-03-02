Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbZCBNPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbZCBNPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 08:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZCBNP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 08:15:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4021 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbZCBNP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:15:29 -0500
Date: Mon, 2 Mar 2009 13:15:14 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-ID: <20090302131514.GC19744@sirena.org.uk>
References: <49A962F8.30609@s5r6.in-berlin.de> <20090228164627.GC15127@sirena.org.uk> <49A97563.6040906@s5r6.in-berlin.de> <20090228175218.GA4606@sirena.org.uk> <49A98F93.5030206@s5r6.in-berlin.de> <20090228210223.GA23191@sirena.org.uk> <49A9C252.50204@s5r6.in-berlin.de> <20090301001829.GA10751@mit.edu> <20090301004618.GA12909@sirena.org.uk> <20090301025357.GC10751@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090301025357.GC10751@mit.edu>
X-Cookie: What hath Bob wrought?
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 09:53:57PM -0500, Theodore Tso wrote:

> Who's been complaining?  I can certainly tell you I'll complain in the
> opposite direction, but that's because it actually causes me more work

Andrew Morton is one of them but not the only one.  Like I say, I don't
want to claim that my changelogs are always ideal here, it was mostly
the specific language used that made me think of doing this.

> as a maintainer.  If people are kvetching, maybe they should complain
> to git mailing list and ask for a different git commit to e-mail
> message convention --- but it's really not hard to look at the subject
> line.

Any attempt to change the format to handle this would presumably also
end up confusing other tools that work with patches, though (at least to
the point of causing the first line of the commit log to be replicated).
