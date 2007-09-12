Return-Path: <linux-kernel-owner+w=401wt.eu-S1762498AbXILWuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762498AbXILWuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 18:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbXILWuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 18:50:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40885 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXILWuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 18:50:04 -0400
Date: Wed, 12 Sep 2007 23:49:55 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Brent Casavant <bcasavan@sgi.com>
Cc: Andreas Schwab <schwab@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: O_NOLINK for open()
Message-ID: <20070912224955.GC8181@ftp.linux.org.uk>
References: <20070912144128.D5573@pkunk.americas.sgi.com> <jetzpza7ci.fsf@sykes.suse.de> <20070912172519.N5573@pkunk.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912172519.N5573@pkunk.americas.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 05:44:30PM -0500, Brent Casavant wrote:

> P.S. By the way, there doesn't seem to be a way to remove /proc/#/mem
>      files.  That might be an additional nicety -- programs worried about
>      being snooped could unlink their own entry.  /dev/mem and /dev/kmem
>      can simply be removed by the sysadmin of such a system.  If all of
>      that were done you'd have to resort to attacking crash dumps, core
>      dumps, or via something like kdb to extract "hidden" data.

Give me a break.  And learn about ptrace(2).  This "unlinking" bullshit
buys you zero additional security, both for /proc/*/mem and for /dev/mem
(see mknod(2)).
