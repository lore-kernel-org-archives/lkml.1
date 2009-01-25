Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZAYVfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZAYVfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 16:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZAYVfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 16:35:37 -0500
Received: from kroah.org ([198.145.64.141]:57061 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751318AbZAYVfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 16:35:36 -0500
Date: Sun, 25 Jan 2009 13:34:03 -0800
From: Greg KH <greg@kroah.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Greg KH <gregkh@suse.de>, Mike Frysinger <vapier.adi@gmail.com>,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: debugfs & vfs file permission issue?
Message-ID: <20090125213403.GB3600@kroah.com>
References: <200901052157.07306.rgetz@blackfin.uclinux.org> <8bd0f97a0901052232l22b60386pbcd9438cc752638f@mail.gmail.com> <200901060705.33294.rgetz@blackfin.uclinux.org> <200901061012.38888.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901061012.38888.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 10:12:38AM -0500, Robin Getz wrote:
> On Tue 6 Jan 2009 07:05, Robin Getz suggested:
> >
> > adding a readonly, and writeonly, and ensuring that when you call 
> > debugfs_create_*, the mode is checked, and the "correct" fops are set 
> > doesn't seem like it would be a bad idea? This would enforce the
> > kernel programmer's view on the world, and not allow pesky root users
> > to override things....
> > 
> > Greg - would you take something like that?
> 
> How about this?
> 
> Feel free to nak it - we can do the same thing where we are calling the
> debugfs_create_* functions - this just makes it cleaner in my opinion.

I like the patch, but there are no changes to the debugfs.h file, which
I think you need.

Care to resend it with the needed header file changes so that I can
apply it?

thanks,

greg k-h
