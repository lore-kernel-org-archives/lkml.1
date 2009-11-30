Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbZK3SLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbZK3SLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 13:11:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZK3SLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 13:11:07 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36790 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbZK3SLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 13:11:07 -0500
Date: Mon, 30 Nov 2009 19:11:09 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kbuild@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: specify absolute paths for cscope
Message-ID: <20091130181109.GA19614@merkur.ravnborg.org>
References: <1259238852-21214-1-git-send-email-daniel.vetter@ffwll.ch> <4B13FD4B.5080805@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B13FD4B.5080805@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 06:13:47PM +0100, Michal Marek wrote:
> On 26.11.2009 13:34, Daniel Vetter wrote:
> > Some tools (like my favourite editor, vim) can't handle relative
> > paths from cscope as soon as cscope.out is no longer in $PWD. Use
> > absolute paths when generating cscope.files, which seems to be
> > the recommended way to generate cscope.out, anyway (at least according
> > to cscope.sf.net).
> 
> But it will fail if you rename the source directory. I'm not sure what
> is worse, I myself don't use cscope much. Fixing vim would be the ideal
> solution of course (it already handles ../tags fine).

For tags I recall we fall back to absolute path only for O=... builds.
This made the tags file considerably smaller for a non O=.. build
thus speeding up the search.

So unconditionally using absolute paths for cscope may have drawbacks.

	Sam
