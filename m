Return-Path: <linux-kernel-owner+w=401wt.eu-S1751572AbYJURI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbYJURI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYJURIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:08:35 -0400
Received: from kroah.org ([198.145.64.141]:44913 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751897AbYJURIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:08:34 -0400
Date: Tue, 21 Oct 2008 10:00:02 -0700
From: Greg KH <greg@kroah.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.2] Unnamed entry appears in
	/sys/module/usbcore/parameters/ .
Message-ID: <20081021170002.GA24940@kroah.com>
References: <200810210838.m9L8cegu033608@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810210838.m9L8cegu033608@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 05:38:40PM +0900, Tetsuo Handa wrote:
> There appears an entry which has no name.
> -----
> # cat /proc/version
> Linux version 2.6.27.2 (root@tomoyo) (gcc version 3.3.5 (Debian 1:3.3.5-13)) #1 SMP Tue Oct 21 17:27:55 JST 2008
> # ls -ail /sys/module/usbcore/parameters/
> total 0
> 236 drwxr-xr-x  2 root root    0 Oct 21 17:31

This one?

Wierd, I don't see this on 2.6.27.2 here.

> 236 drwxr-xr-x  2 root root    0 Oct 21 17:31 .
> 235 drwxr-xr-x  4 root root    0 Oct 21 17:31 ..
> 237 -rw-r--r--  1 root root 4096 Oct 21 17:31 autosuspend
> 239 -r--r--r--  1 root root 4096 Oct 21 17:31 blinkenlights
> 240 -rw-r--r--  1 root root 4096 Oct 21 17:31 old_scheme_first
> 241 -rw-r--r--  1 root root 4096 Oct 21 17:31 use_both_schemes
> # ls -aild /sys/module/usbcore/parameters/
> 236 drwxr-xr-x  2 root root 0 Oct 21 17:31 /sys/module/usbcore/parameters/
> #
> -----
> No such behavior for kernel 2.6.26.6 .
> Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.27.2 .

How about on 2.6.27-git releases?

thanks,

greg k-h
