Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYBIGj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYBIGj5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 01:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYBIGju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 01:39:50 -0500
Received: from verein.lst.de ([213.95.11.210]:37542 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577AbYBIGjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 01:39:49 -0500
Date: Sat, 9 Feb 2008 07:39:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@lst.de, viro@ZenIV.linux.org.uk,
       viro@ftp.linux.org.uk, miklos@szeredi.hu
Subject: Re: [RFC][PATCH 00/30] Read-only bind mounts (-mm resend)
Message-ID: <20080209063936.GA29759@lst.de>
References: <20080208222641.6024A7CC@kernel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208222641.6024A7CC@kernel>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 02:26:41PM -0800, Dave Hansen wrote:
> This is against current Linus git
> (a4ffc0a0b240a29cbe489f6db9dae112a49ef1c1).
> 
> This rolls up all the -mm bugfixes that were accumulated, and
> addresses some new review comments from Al.  Also contains some
> reworking from hch and a patch from Jeff Dike.
> 
> Just posting here to let everyone have a sniff before we resend
> it back to -mm.

Except for the comment snafu in patch 8 this looks good to me.
Feel free to add


Signed-off-by: Christoph Hellwig <hch@lst.de>

as after all the reshuffling and tweaking I should share my fair share
of blame if things go wrong after all.

Do we really want to do another detour to -mm?  I think we should be
heading towards Linus' tree ASAP with this.

