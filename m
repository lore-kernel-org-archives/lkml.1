Return-Path: <linux-kernel-owner+w=401wt.eu-S968079AbXGaDbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968079AbXGaDbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbXGaDbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:31:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45549 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965323AbXGaDbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:31:34 -0400
Date: Tue, 31 Jul 2007 04:31:33 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: inotify and /proc/<pid>
Message-ID: <20070731033133.GG21089@ftp.linux.org.uk>
References: <20070731021615.GB6812@digitasaru.net> <20070731031720.GF21089@ftp.linux.org.uk> <20070731032521.GD6812@digitasaru.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731032521.GD6812@digitasaru.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 10:25:21PM -0500, Joseph Pingenot wrote:
> >From Al Viro on Tuesday, 31 July, 2007:
> >On Mon, Jul 30, 2007 at 09:16:16PM -0500, Joseph Pingenot wrote:
> >> I was trying to use inotify to watch process changes (especially process
> >>   termination) by watching /proc/<pid>.
> >> Sadly, although I could see something reading various files, nothing
> >>   was issued when the process I was watching exited and the directory
> >>   went away.
> >> Is this intentional, or a bug?
> >It's a bug you intend to introduce in your program...  IOW, don't
> >do that.
> 
> More background, please?
> 
> What's the way to check for a process exiting without spinning?

Depends on what that process is and how it is related to watching
one...
