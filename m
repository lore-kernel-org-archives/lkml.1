Return-Path: <linux-kernel-owner+w=401wt.eu-S968079AbXGaDRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968079AbXGaDRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 23:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759950AbXGaDRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 23:17:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39047 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759397AbXGaDRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 23:17:21 -0400
Date: Tue, 31 Jul 2007 04:17:20 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: linux-kernel@vger.kernel.org
Subject: Re: inotify and /proc/<pid>
Message-ID: <20070731031720.GF21089@ftp.linux.org.uk>
References: <20070731021615.GB6812@digitasaru.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731021615.GB6812@digitasaru.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 09:16:16PM -0500, Joseph Pingenot wrote:
> I was trying to use inotify to watch process changes (especially process
>   termination) by watching /proc/<pid>.
> 
> Sadly, although I could see something reading various files, nothing
>   was issued when the process I was watching exited and the directory
>   went away.
> 
> Is this intentional, or a bug?

It's a bug you intend to introduce in your program...  IOW, don't
do that.
