Return-Path: <linux-kernel-owner+w=401wt.eu-S932709AbYBGWRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbYBGWRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbYBGWRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:17:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963AbYBGWRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:17:37 -0500
Date: Thu, 7 Feb 2008 14:17:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, Joel.Becker@oracle.com
Subject: Re: [git patches] ocfs2 update
Message-Id: <20080207141706.33604c50.akpm@linux-foundation.org>
In-Reply-To: <20080207213714.GR22671@ca-server1.us.oracle.com>
References: <20080207200944.GQ22671@ca-server1.us.oracle.com>
	<20080207124745.4868e108.akpm@linux-foundation.org>
	<20080207213714.GR22671@ca-server1.us.oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 13:37:15 -0800
Mark Fasheh <mark.fasheh@oracle.com> wrote:

> > Please integrate checkpatch into your processes - this one had a few little
> > glitches.
> 
> FWIW - I've run all patches through checkpatch.pl since your last review.

cool, thanks.

> This one went through a couple cycles of checkpatch actually :) There's
> three warnings that I get:
> 
> ERROR: "foo * bar" should be "foo *bar"
> #70: FILE: fs/ocfs2/dlm/dlmapi.h:200:
> +struct dlm_ctxt * dlm_register_domain(const char *domain, u32 key,
> 
> WARNING: line over 80 characters
> #269: FILE: fs/ocfs2/dlm/dlmdomain.c:813:
> +
> #&dlm->fs_locking_proto,
> 
> WARNING: line over 80 characters
> #270: FILE: fs/ocfs2/dlm/dlmdomain.c:814:
> +
> #&query->fs_proto)) {
> 
> total: 1 errors, 2 warnings, 569 lines checked
> 
> 
> The "foo * bar" one is from existing code which got moved, and I felt that
> leaving them unmodified was cleaner from a patch-reading perspective.

I tend to clean those things up as we go, because it's a free patch.

otoh I see that dlm style is presently space-after-asterisk so there's not
a lot of point in fixing just one of them.

> The over 80 characters warnings were ignored as the code seemed more
> readable as-is.

yes, I tend to ignore those warnings unless the mess is really gratuitous or
if the surrounding code has obviously made some effort to avoid the problem.

> I guess a lot of this can be subjective though, so I can be super strict if
> you really feel it's necessary.

No, you shouldn't view checkpatch as a things-i-must-do.  It is a
things-i-might-have-missed tool.  If you _meant_ things to be that way then
fine, ignore it.
