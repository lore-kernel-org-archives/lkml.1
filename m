Return-Path: <linux-kernel-owner+w=401wt.eu-S935253AbXHOTUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935253AbXHOTUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 15:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXHOTUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 15:20:20 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:48630 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbXHOTUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 15:20:19 -0400
Date: Wed, 15 Aug 2007 15:20:17 -0400
To: Marc Perkel <mperkel@yahoo.com>
Cc: Valdis.Kletnieks@vt.edu, Kyle Moffett <mrmacman_g4@mac.com>,
       Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Thinking outside the box on file systems
Message-ID: <20070815192017.GD9410@csclub.uwaterloo.ca>
References: <19705.1187197065@turing-police.cc.vt.edu> <763705.7247.qm@web52512.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <763705.7247.qm@web52512.mail.re2.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 10:09:31AM -0700, Marc Perkel wrote:
> Yep - way outside the box - and thus the title of the
> thread.
> 
> The idea is that people have permissions - not files.
> By people I mean users, groups, managers, applications
> etc. One might even specify that there are no
> permission restrictions at all. Part of the process
> would be that the kernel load what code it will use
> for the permission system. It might even be a little
> perl script you write.
> 
> 
> Also - you aren't even giving permission to access
> files. It's permission to access name patterns. One
> could apply REGEX masks to names to determine
> permissions. So if you have permission to the name you
> have permission to the file.

So if I have permission to access /foo/*x but no permission to access
/foo/*y, do I have permission to rename /foo/123x to /foo/123y and if I
do so, do I loose access to my file?  Can I move it back?

> Hard links would be multiple names pointing to the
> same file. Simlinks would be name aliases.

I think I prefer to keep my files inside the box.  That way I won't need
to get a bucket. :)

--
Len Sorensen
