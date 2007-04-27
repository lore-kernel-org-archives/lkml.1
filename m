Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbXD0VFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbXD0VFu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbXD0VFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:05:48 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757294AbXD0VF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:05:27 -0400
Date: Fri, 27 Apr 2007 14:04:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, adobriyan@openvz.org
Subject: Re: [PATCH] v4: merged utimensat implementation
Message-Id: <20070427140450.3938183c.akpm@linux-foundation.org>
In-Reply-To: <200704271523.l3RFNwGN031209@devserv.devel.redhat.com>
References: <200704271523.l3RFNwGN031209@devserv.devel.redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 11:23:58 -0400
Ulrich Drepper <drepper@redhat.com> wrote:

> I took Alexey's lutimes patches and merged it with the utimensat patch.
> Fortunately Alexey already did most of the work, the conversion to
> timespec.  I just changed the name of the syscall, made the flag part
> of the syscall parameters, and did away with the old do_utimes definition
> (the new do_utimes takes a timespec and a flag now).  All five patches
> patches are rolled into one.
> 
> Note, at userlevel I don't intend to expose the flags parameter.  We'll
> have separate utimensat and lutimensat interfaces.  But there is no
> reason to duplicate all that code in the kernel.

Could we please have a signoff for this work from Alexey and a changelog
for the commit?  I could grab the description from the initial utimensat
email, but I guess it needs updating now.
