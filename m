Return-Path: <linux-kernel-owner+w=401wt.eu-S940636AbXGaDsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940636AbXGaDsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935445AbXGaDsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:48:43 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:34229 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761350AbXGaDsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:48:43 -0400
Date: Mon, 30 Jul 2007 23:48:41 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Joseph Pingenot <trelane@digitasaru.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: inotify and /proc/<pid>
Message-ID: <20070731034841.GA16495@fattire.cabal.ca>
References: <20070731021615.GB6812@digitasaru.net> <20070731031720.GF21089@ftp.linux.org.uk> <20070731032521.GD6812@digitasaru.net> <20070731033113.GE6812@digitasaru.net> <20070731033631.GH21089@ftp.linux.org.uk> <20070731034059.GF6812@digitasaru.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731034059.GF6812@digitasaru.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 10:40:59PM -0500, Joseph Pingenot wrote:
> From Al Viro on Tuesday, 31 July, 2007:
> >On Mon, Jul 30, 2007 at 10:31:13PM -0500, Joseph Pingenot wrote:
> >> >From Joseph Pingenot on Monday, 30 July, 2007:
> >> >From Al Viro on Tuesday, 31 July, 2007:
> >> >>On Mon, Jul 30, 2007 at 09:16:16PM -0500, Joseph Pingenot wrote:
> >> >>> I was trying to use inotify to watch process changes (especially process
> >> >>>   termination) by watching /proc/<pid>.
> >> >>> Sadly, although I could see something reading various files, nothing
> >> >>>   was issued when the process I was watching exited and the directory
> >> >>>   went away.
> >> >>> Is this intentional, or a bug?
> >> >>It's a bug you intend to introduce in your program...  IOW, don't
> >> >>do that.
> >> >More background, please?
> >> >What's the way to check for a process exiting without spinning?
> >> I should also specify that the process being waited on is not a
> >>   child process-it's just some other process on the system.
> >Umm...  Any details on intended use?  IOW, is that "I want to write
> >an utility that would wait for given PID to exit, just for the hell
> >of it" or is there something you are trying to implement using that?
> 
> I'm trying to implement pwait.  It blocks until a specified PID exits,
>   and then it exits.
>

ptrace with options set to PTRACE_O_TRACEEXIT?

--Kyle
