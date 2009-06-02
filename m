Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZFBXaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZFBXaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZFBX36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:29:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbZFBX35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:29:57 -0400
Date: Tue, 2 Jun 2009 16:23:10 -0700
From: Greg KH <gregkh@suse.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Robin Getz <rgetz@blackfin.uclinux.org>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] debugfs: use specified mode to possibly mark files
	read/write only
Message-ID: <20090602232310.GA26919@suse.de>
References: <20090125213403.GB3600@kroah.com> <1243926047-29704-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243926047-29704-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 03:00:47AM -0400, Mike Frysinger wrote:
> From: Robin Getz <rgetz@blackfin.uclinux.org>
> 
> In many SoC implementations there are hardware registers can be read or
> write only.  This extends the debugfs to enforce the file permissions for
> these types of registers by providing a set of fops which are read or
> write only.  This assumes that the kernel developer knows more about the
> hardware than the user (even root users) -- which is normally true.
> 
> Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
> you mention debugfs header file changes, but i don't see what would need
> changing ?  the mode checking is all done internally ...

Looks good to me.

