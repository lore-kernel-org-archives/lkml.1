Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752983AbYLQT7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbYLQT7h (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYLQT6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:58:52 -0500
Received: from kroah.org ([198.145.64.141]:35617 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751803AbYLQT6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:58:52 -0500
Date: Wed, 17 Dec 2008 11:56:20 -0800
From: Greg KH <greg@kroah.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [stable] [BUG] Upon hitting ^c, inotify blocks on mutex_lock
Message-ID: <20081217195620.GA25375@kroah.com>
References: <20081213164123.GB7639@flint.arm.linux.org.uk> <20081217194855.GA11188@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217194855.GA11188@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 07:48:56PM +0000, Russell King wrote:
> On Sat, Dec 13, 2008 at 04:41:23PM +0000, Russell King wrote:
> > Today, having had gthumb running for a while, I hit ^c expecting it to
> > quit.  The result was a process with zero VSZ and RSS, and it sitting
> > in run state.  Only possible recovery action seems to be a reboot.
> 
> Al Viro looked into this, and suggested that 711a49a might fix the
> problem.  I've just tested this on top of 2.6.27.8, and it does
> indeed appear to fix the problem.  Suggest it should be included
> in the next stable kernel.

It's already queued up for the 2.6.27.10 release to be happening
tomorrow :)

thanks,

greg k-h
