Return-Path: <linux-kernel-owner+w=401wt.eu-S967935AbXGaDgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967935AbXGaDgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938483AbXGaDgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:36:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45213 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938775AbXGaDgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:36:32 -0400
Date: Tue, 31 Jul 2007 04:36:31 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: inotify and /proc/<pid>
Message-ID: <20070731033631.GH21089@ftp.linux.org.uk>
References: <20070731021615.GB6812@digitasaru.net> <20070731031720.GF21089@ftp.linux.org.uk> <20070731032521.GD6812@digitasaru.net> <20070731033113.GE6812@digitasaru.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731033113.GE6812@digitasaru.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 10:31:13PM -0500, Joseph Pingenot wrote:
> >From Joseph Pingenot on Monday, 30 July, 2007:
> >From Al Viro on Tuesday, 31 July, 2007:
> >>On Mon, Jul 30, 2007 at 09:16:16PM -0500, Joseph Pingenot wrote:
> >>> I was trying to use inotify to watch process changes (especially process
> >>>   termination) by watching /proc/<pid>.
> >>> Sadly, although I could see something reading various files, nothing
> >>>   was issued when the process I was watching exited and the directory
> >>>   went away.
> >>> Is this intentional, or a bug?
> >>It's a bug you intend to introduce in your program...  IOW, don't
> >>do that.
> >More background, please?
> >What's the way to check for a process exiting without spinning?
> 
> I should also specify that the process being waited on is not a
>   child process-it's just some other process on the system.

Umm...  Any details on intended use?  IOW, is that "I want to write
an utility that would wait for given PID to exit, just for the hell
of it" or is there something you are trying to implement using that?
