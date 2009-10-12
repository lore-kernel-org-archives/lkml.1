Return-Path: <linux-kernel-owner+w=401wt.eu-S933372AbZJLXMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbZJLXMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 19:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757168AbZJLXMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 19:12:51 -0400
Received: from thunk.org ([69.25.196.29]:41525 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbZJLXMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 19:12:50 -0400
Date: Mon, 12 Oct 2009 19:12:11 -0400
From: Theodore Tso <tytso@mit.edu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Weird ext4 bug: 256P used?
Message-ID: <20091012231211.GC18195@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <94a0d4530910120651i18ce33d2k89abcd66d1b865a1@mail.gmail.com> <20091012222910.GB18195@mit.edu> <94a0d4530910121602i14f34150h18d388668fc355d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94a0d4530910121602i14f34150h18d388668fc355d9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 02:02:31AM +0300, Felipe Contreras wrote:
> 
> However, there's no file so big:
> ls -lh /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586
> total 12K
> -rw-r--r-- 1 root root 24 2009-07-27 20:52 from_repo
> -rw-r--r-- 1 root root  4 2009-07-27 20:52 reason
> -rw-r--r-- 1 root root  2 2009-07-27 20:52 releasever
> 
> However, there's something messed up with the uid/gid:
> 
> ls -ld /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586
> drwxr-xr-x 2 4294901760 16711680 4096 2009-07-27 20:52
> /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.0.0.72-fc5-i586

OK, how about the output of

stat /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.\
0.0.72-fc5-i586

and 

stat /var/lib/yum/yumdb/s/160f96bb8689bae7bed1f8801385845d47913ace-skype-2.\
0.0.72-fc5-i586/*

Thanks,

						- Ted
