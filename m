Return-Path: <linux-kernel-owner+w=401wt.eu-S1763594AbXJZSHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763594AbXJZSHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761107AbXJZSHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:07:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55788 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758788AbXJZSHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:07:22 -0400
Date: Fri, 26 Oct 2007 11:06:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] proc: Fix proc_kill_inodes to kill dentries on all proc
 superblocks
In-Reply-To: <m1y7dp22d4.fsf@ebiederm.dsl.xmission.com>
Message-ID: <alpine.LFD.0.999.0710261105440.30120@woody.linux-foundation.org>
References: <m1y7dp22d4.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Eric W. Biederman wrote:
> 
> It appears we overlooked support for removing generic proc files
> when we added support for multiple proc super blocks.  Handle
> that now.

There seems to be more users of "proc_mnt" out there. proc_flush_task, 
anyone?

		Linus
