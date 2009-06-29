Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbZF2XCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbZF2XCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZF2XCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:02:08 -0400
Received: from kroah.org ([198.145.64.141]:48176 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbZF2XCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:02:07 -0400
Date: Mon, 29 Jun 2009 15:52:21 -0700
From: Greg KH <greg@kroah.com>
To: tridge@samba.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Eric W. Biederman" <ebiederm@xmission.com>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090629225221.GA16870@kroah.com>
References: <19013.8005.541836.436991@samba.org> <m1d48p5dil.fsf@fess.ebiederm.org> <19014.54044.484370.187018@samba.org> <m1vdmh2e26.fsf@fess.ebiederm.org> <19015.482.794111.612472@samba.org> <87ab3sx4ch.fsf@devron.myhome.or.jp> <19016.6463.997760.757811@samba.org> <20090629221826.GA12781@kroah.com> <19017.17250.371594.268824@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19017.17250.371594.268824@samba.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 08:42:42AM +1000, tridge@samba.org wrote:
>  > I have no objection to take this patch for the -stable releases when it
>  > goes into Linus's tree.  Just forward the git commit ids to
>  > stable@kernel.org and I can take care of it.
> 
> ok, thanks Greg.
> 
> Hirofumi-san tells me we've missed the merge window for 2.6.31, so it
> seems that this will go first into the fatfs tree, then go into
> Linus's tree via -next for 2.6.32. So hopefully the patch will get
> some more testing (perhaps in -mm?) before it needs to be considered
> for -stable.

That sounds reasonable.  Just add a:
	Cc: stable <stable@kernel.org>
in the "signed-off-by:" area of the patch, and when it goes into Linus's
tree, the -stable team will be automatically notified of it and we will
pick it up.

It needs to be in Linus's tree before we can add it to the -stable
releases.

thanks,

greg k-h
