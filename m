Return-Path: <linux-kernel-owner+w=401wt.eu-S972237AbXHMMk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972237AbXHMMk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940932AbXHMHQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:16:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41985 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940918AbXHMHQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:16:10 -0400
Date: Mon, 13 Aug 2007 08:16:06 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch - scripts/get_maintainer.pl
Message-ID: <20070813071606.GF21089@ftp.linux.org.uk>
References: <1186984174.10249.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186984174.10249.7.camel@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 10:49:34PM -0700, Joe Perches wrote:
> I grew weary of looking up the appropriate
> maintainer email address(es) to CC: for a patch.

Does the acronym GAFL ring any bells?  It's not that idea is worthless -
it sure as hell is a useful thing, but what the bleeding hell is that
splitup supposed to achieve?

Please, people, try to think for a minute.  Patch series are good not
just because; there are rational reasons for that.  None of those
applies here; if anything, you've made sure that this patchbomb will
be less reviewed.

Seriously, get a fucking life.  This is way past ridiculous.  It does not
make changes easier to test.  It does not help bisect.  It does not help
to make changes more self-contained.  It does not reduce the odds of
conflict with pending patches.  It does not simplify conflict resolution
when porting.  It does not split the change into easier understood parts.
Hell, it doesn't even make it easier to revert broken parts.

Use the common sense, folks.  Please.
