Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215Ab0AVBZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0AVBZt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023Ab0AVBZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:25:48 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60175 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab0AVBZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:25:45 -0500
Date: Fri, 22 Jan 2010 01:25:44 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stepan Chatalyan <kehcho@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hi all, bug or design flaw?
Message-ID: <20100122012544.GV19799@ZenIV.linux.org.uk>
References: <22d9728d1001211705i4cf90df2ha730061ea01972b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22d9728d1001211705i4cf90df2ha730061ea01972b6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 22, 2010 at 02:05:50AM +0100, Stepan Chatalyan wrote:
> (1) I mount /tmp with noexec,nosuid,nodev options

> (4) I tried to execute it, but pass to bash ". /tmp/createdfile"
> 
> [kehcho@tornadowt] [/tmp]$ . /tmp/createdfile
> Probe...
> 
> It is a kernel bug or I just report a another one?

What the hell does it have to do with the kernel?  You've told shell
to open a text file, read it and interpret its contents line by line.
It had done as instructed.  Moreover, bash /tmp/createdfile would work
just as fine.  Neither of those would attempt to do execve() on the
file in question; you are just telling shell what to open and read.
