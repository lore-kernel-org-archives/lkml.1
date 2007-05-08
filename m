Return-Path: <linux-kernel-owner+w=401wt.eu-S967626AbXEHCdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967626AbXEHCdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 22:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967618AbXEHCc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 22:32:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42179 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966892AbXEHCc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 22:32:58 -0400
Date: Tue, 8 May 2007 12:32:39 +1000
From: David Chinner <dgc@sgi.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       xfs-masters@oss.sgi.com
Subject: Re: xfs_ilock: possible recursive locking detected
Message-ID: <20070508023239.GB32602149@melbourne.sgi.com>
References: <463E5A5D.1070509@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <463E5A5D.1070509@simon.arlott.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 11:44:45PM +0100, Simon Arlott wrote:
> [  119.948000] =============================================
> [  119.948000] [ INFO: possible recursive locking detected ]
> [  119.948000] 2.6.21-git #185
> [  119.948000] ---------------------------------------------
> [  119.948000] cc1/6496 is trying to acquire lock:
> [  119.948000]  (&(&ip->i_lock)->mr_lock){----}, at: [<b025d230>] 
> xfs_ilock+0x60/0xb0
> [  119.948000]
> [  119.948000] but task is already holding lock:
> [  119.948000]  (&(&ip->i_lock)->mr_lock){----}, at: [<b025d230>] 
> xfs_ilock+0x60/0xb0
> [  119.948000]

Known false positive. There shoul dbe a git update for Linus in the
next couple of days that has the lockdep annotations needed to prevent
these false positives from coming up....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
