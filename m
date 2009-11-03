Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbZKDGvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbZKDGvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZKDGvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:51:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34635 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZKDGvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:51:52 -0500
Date: Tue, 3 Nov 2009 15:08:27 -0800
From: Greg KH <gregkh@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Roel Kluin <roel.kluin@gmail.com>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dst: Fix parentheses
Message-ID: <20091103230827.GA746@suse.de>
References: <4AF0B35A.8080400@gmail.com> <20091103225343.GA9145@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103225343.GA9145@ioremap.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 01:53:43AM +0300, Evgeniy Polyakov wrote:
> On Tue, Nov 03, 2009 at 11:48:58PM +0100, Roel Kluin (roel.kluin@gmail.com) wrote:
> > `|' has a higher precedence than `?' so since MSG_WAITALL is
> > defined 0x100, MSG_MORE was always written to the msg_flag.
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> 
> Looks good, thank you!
> Andrew, please queue it into the appropriate tree.

That would be my tree, I'll do it.

thanks,

greg k-h
