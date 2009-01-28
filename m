Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbZA1TeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbZA1TeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:34:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZA1Tdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:33:54 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:39358 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbZA1Tdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:33:53 -0500
Subject: Re: Linux 2.6.27.13
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jesper Krogh <jesper@krogh.cc>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-nfs@vger.kernel.org, autofs@linux.kernel.org
In-Reply-To: <4980565E.3000800@krogh.cc>
References: <20090125004823.GA6711@kroah.com>  <4980565E.3000800@krogh.cc>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 14:33:47 -0500
Message-Id: <1233171227.9785.28.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: BA2B04D9B7D7B836691635FD6B8855DCA29C0835
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 2 total 401 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 13:58 +0100, Jesper Krogh wrote:
> Greg KH wrote:
> > We (the -stable team) are announcing the release of the 2.6.27.13
> > kernel.
> > 
> > It contains a wide range of bugfixes, and all users of the 2.6.27 kernel
> > series are strongly encouraged to upgrade.
> > 
> > I'll also be replying to this message with a copy of the patch between
> > 2.6.27.12 and 2.6.27.13
> 
> Still on a 2.6.27.6  I got this on an NFS client while restarting the 
> NFS-server at the other end. Seems autofs/nfs releated.
> 
> 
> [6367172.212954] ------------[ cut here ]------------
> [6367172.213122] kernel BUG at net/sunrpc/rpcb_clnt.c:498!

Already fixed in 2.6.28 by the following commit.
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git&a=commitdiff&h=9a4bd29fe8f6d3f015fe1c8e5450eb62cfebfcc9

You should probably also apply the following commit (also in 2.6.28),
which fixes a memory leak in the same area.
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git&a=commitdiff&h=96165e2b7c4e2c82a0b60c766d4a2036444c21a0

Cheers
  Trond

