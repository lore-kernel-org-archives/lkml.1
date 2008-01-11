Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbYAKOBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbYAKOBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbYAKOBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:01:04 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37981 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYAKOBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:01:03 -0500
Date: Fri, 11 Jan 2008 07:01:02 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Random number driver: make random_ioctl as an unlocked_ioctl function
Message-ID: <20080111140101.GL18741@parisc-linux.org>
References: <1200051592.3844.63.camel@nikanth-laptop.blr.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200051592.3844.63.camel@nikanth-laptop.blr.novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 05:09:52PM +0530, Nikanth Karthikesan wrote:
> The random_ioctl is registered as an ioctl function but it does not
> require BKL to be held when called. Changing it as an unlocked_ioctl
> function.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

Acked-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
