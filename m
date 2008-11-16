Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYKPWo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYKPWo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYKPWoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:44:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:6012 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbYKPWoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:44:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=AvgQgZNx/q14Ar2Dj4ZqHVZF+WTvENg8ftLQ6tEvdi2vdBp4kvSmK7blu58JLtgbAw
         xeMYO9ERLEKgqav/p+SGtdp+ERgsK2f1irUvfEstSvfPskQqezVck1OF8IEl3LXYGokf
         0ioNFPiuHe2XNxCCYfRdc/eglK+2qEST2vUjs=
Message-ID: <4920A23B.2060100@gmail.com>
Date: Sun, 16 Nov 2008 23:44:11 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Peter Palfrader <peter@palfrader.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: broken ownership of /proc/sys/ files on 2.6.27
References: <20081116205922.GI28958@anguilla.noreply.org> <20081116221910.GQ28946@ZenIV.linux.org.uk>
In-Reply-To: <20081116221910.GQ28946@ZenIV.linux.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2008 11:19 PM, Al Viro wrote:
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -31,6 +31,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
>  	inode->i_flags |= S_PRIVATE; /* tell selinux to ignore this inode */

And what about this    ^, is it OK?
