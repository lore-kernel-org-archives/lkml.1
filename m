Return-Path: <linux-kernel-owner+w=401wt.eu-S1761262AbZLJVaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262AbZLJVaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761030AbZLJVaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:30:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760945AbZLJVaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:30:09 -0500
Date: Thu, 10 Dec 2009 16:25:33 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/41] VFS: Remove unnecessary micro-optimization in cached_lookup()
Message-ID: <20091210212533.GD10388@shell>
References: <1256152779-10054-5-git-send-email-vaurora@redhat.com> <200911300207.nAU27duL007220@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300207.nAU27duL007220@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 29, 2009 at 09:07:39PM -0500, Erez Zadok wrote:
> In message <1256152779-10054-5-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > d_lookup() takes rename_lock which is a seq_lock.  This is so cheap
> > it's not worth calling lockless __d_lookup() first from
> > cache_lookup().  Rename cached_lookup() to cache_lookup() while we're
> > there.
> 
> Val, this is another patch unrelated to union mounts, an
> optimization/simplification of the VFS code.  I think you need to try and
> push such VFS patches upstream more quickly, so as to reduce the set of UM
> patches you have to maintain.

I agree.  We posted them separately once and will do so again.

-VAL
