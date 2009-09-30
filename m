Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbZI3UZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbZI3UZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbZI3UZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:25:25 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:35615 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbZI3UZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:25:24 -0400
Date: Wed, 30 Sep 2009 16:25:27 -0400
To: Jakub Narebski <jnareb@gmail.com>
Cc: Alejandro Riveira =?utf-8?Q?Fern=C3=A1ndez?= <ariveira@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Andy <genanr@emsphone.com>,
       linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: How can I download a git commit as a diff patch?
Message-ID: <20090930202527.GB22159@csclub.uwaterloo.ca>
References: <20090930154410.GA31502@thumper2> <20090930085500.a5856301.rdunlap@xenotime.net> <20090930190014.GA22161@csclub.uwaterloo.ca> <20090930213809.71c2a8e8@varda> <m3tyyk9ost.fsf@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3tyyk9ost.fsf@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 01:10:51PM -0700, Jakub Narebski wrote:
> Or better yet, if given installation of gitweb supports it, on the
> 'patch' link just on the right of 'raw' view.  Such patch can be
> applied better by git-am (but both should work for GNU patch or
> git-apply).
> 
> Yes, by default for merges the 'commitdiff' view (and the 'raw'
> version, i.e. 'commitdiff_plain' view) shows **combined** diff of
> changes brought by merge (see git-diff manpage for details on this
> format).
> 
> For merge commit you have to choose which of parents you want to have
> diff from.  Go to 'commit' view, there in the header would be two or
> more parents.  Click on the 'diff' link beside chosen parent, check if
> it is the diff you want to get, and then click on 'patch' (or 'raw')
> link.

Is there a git command to show me a diff I can use with patch if I want to
select a given patch as long as I can tell it which tree I want to follow?
I don't care to use gitweb if I can do it with the command line git.

git show obviously shows the git combined diff format, at least by default.

Or is the idea of trying to use the diff from the merge commit just
silly in the first place?

-- 
Len Sorensen
