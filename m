Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752762AbYLQTyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYLQTyY (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYLQTyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:54:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60492 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbYLQTyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:54:07 -0500
Date: Wed, 17 Dec 2008 19:48:56 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>, stable@kernel.org
Cc: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [BUG] Upon hitting ^c, inotify blocks on mutex_lock
Message-ID: <20081217194855.GA11188@flint.arm.linux.org.uk>
References: <20081213164123.GB7639@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081213164123.GB7639@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 04:41:23PM +0000, Russell King wrote:
> Today, having had gthumb running for a while, I hit ^c expecting it to
> quit.  The result was a process with zero VSZ and RSS, and it sitting
> in run state.  Only possible recovery action seems to be a reboot.

Al Viro looked into this, and suggested that 711a49a might fix the
problem.  I've just tested this on top of 2.6.27.8, and it does
indeed appear to fix the problem.  Suggest it should be included
in the next stable kernel.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
