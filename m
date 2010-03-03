Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab0CCT5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:57:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40833 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab0CCT5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:57:18 -0500
Date: Wed, 3 Mar 2010 19:57:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] init: Open /dev/console from rootfs
Message-ID: <20100303195716.GT30031@ZenIV.linux.org.uk>
References: <m1sk8hn8nk.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1sk8hn8nk.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 11:53:19PM -0800, Eric W. Biederman wrote:
> 
> To avoid potential problems with an empty /dev open /dev/console
> from rootfs instead of waiting to mount our root filesystem and
> mounting it there.   This effectively guarantees that there will
> be a device node, and it won't be on a filesystem that we will
> ever unmount, so there are no issues with leaving /dev/console
> open and pinning the filesystem.
> 
> This is actually more effective than automatically mounting
> devtmpfs on /dev because it removes removes the occasionally
> problematic assumption that /dev/console exists from the boot
> code.

Hell, yeah.  Applied, with thanks.
