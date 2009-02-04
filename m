Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbZBDWNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbZBDWNS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZBDWNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:13:04 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:33709 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZBDWND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:13:03 -0500
Date: Wed, 4 Feb 2009 23:14:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Floris Kraak <randakar@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
Message-ID: <20090204221451.GA27254@uranus.ravnborg.org>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 03:28:47PM +0100, Floris Kraak wrote:
> Some distributions have enabled the gcc flag -Wformat-security by default.*
> This results in a number of warnings about format arguments to
> functions, sometimes in cases where fixing the warning is not likely
> to actually fix a bug.
> Instead of hand patching a dozens of places (possibly more) that
> produce warnings that get ignored anyway we just turn off the flag in
> the Makefile.
> 
> Note: Regardless of any discussion surrounding the value of this
> particular type of warning, having this show up in a few distributions
> but not in the
> vast majority of them means that this warning won't be seen by most of
> the developers who introduce the new warnings in the first place. If
> the
> kernel decides it cares about format arguments it should do so
> globally regardless of distribution. In which case I'd gladly whip up
> a patch to do
> the reverse thing and turn this thing on by default. However, such a
> patch would have to produce a follow up patch(set) which fixes each
> individual
> warning.

Before judging on this patch could you please post what warning it
triggers and one or a few patches to fix some of them.

	Sam
