Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZGXXRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZGXXRC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 19:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbZGXXRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 19:17:01 -0400
Received: from mail2.shareable.org ([80.68.89.115]:57406 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZGXXRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 19:17:00 -0400
Date: Sat, 25 Jul 2009 00:16:58 +0100
From: Jamie Lokier <jamie@shareable.org>
To: John Stoffel <john@stoffel.org>
Cc: Andreas Dilger <adilger@sun.com>, Ludwig Nussel <ludwig.nussel@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] implement uid mount option for ext2
Message-ID: <20090724231658.GM27755@shareable.org>
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de> <1248431444-18842-1-git-send-email-ludwig.nussel@suse.de> <1248431444-18842-2-git-send-email-ludwig.nussel@suse.de> <20090724165201.GA4231@webber.adilger.int> <19050.1094.758320.38666@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19050.1094.758320.38666@stoffel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
> I didn't read the original email closely, but I have to say that both
> of these plans don't sound good to me.  If you can mount a filesystem,
> you're root already, so you can do any fixup you need.

What if someone lends you a 1TB disk, for you to browse it in your
favourite GUI or Shell Window to read some files from it?  And you're
to put a couple of files on it before you give it back?

Hotplug scripts run as root to mount it, and you have your GUI / Shell
Window which don't run as root to read and write a few of those files.

You must not chown anything on the disk, because it isn't your disk.

> But in that case, you're screwed anyway and it's going to become
> un-manageable.  Push this to userspace, not the kernel since it's a
> userspace issue when you come right down to it.

How do you handle the above scenario in userspace?

-- Jamie
