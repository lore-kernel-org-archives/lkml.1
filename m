Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbXGaEB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbXGaEB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXGaEBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:01:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49509 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbXGaEBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:01:19 -0400
Date: Tue, 31 Jul 2007 05:01:18 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: inotify and /proc/<pid>
Message-ID: <20070731040118.GJ21089@ftp.linux.org.uk>
References: <20070731021615.GB6812@digitasaru.net> <20070731031720.GF21089@ftp.linux.org.uk> <20070731032521.GD6812@digitasaru.net> <20070731033113.GE6812@digitasaru.net> <20070731033631.GH21089@ftp.linux.org.uk> <20070731034059.GF6812@digitasaru.net> <20070731035023.GI21089@ftp.linux.org.uk> <20070731035626.GG6812@digitasaru.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731035626.GG6812@digitasaru.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 10:56:27PM -0500, Joseph Pingenot wrote:
> >From Al Viro on Tuesday, 31 July, 2007:
> >On Mon, Jul 30, 2007 at 10:40:59PM -0500, Joseph Pingenot wrote:
> >> I'm trying to implement pwait.  It blocks until a specified PID exits,
> >>   and then it exits.
> >er... ptrace(2)?
> 
> Should work for most common usage scenarios, although will suspect that it
>   won't for for processes owned by another user (at least, I hope
>   it wouldn't).
> 
> What is dangerous about inotify on a proc file?

Playing with the lifetime rules, for starters...
