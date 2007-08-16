Return-Path: <linux-kernel-owner+w=401wt.eu-S1763835AbXHPOyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763835AbXHPOyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 10:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760004AbXHPOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 10:54:12 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:50741 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbXHPOyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 10:54:11 -0400
Date: Thu, 16 Aug 2007 10:52:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Joe Perches <joe@perches.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       rolandd@cisco.com, Chas Williams <chas@cmf.nrl.navy.mil>,
       Paul Mundt <lethal@linux-sh.org>, isdn4linux@listserv.isdn4linux.de,
       mikep@linuxtr.net, netdev@vger.kernel.org, swen@vnet.ibm.com,
       linux390@de.ibm.com, linux-s390@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       user-mode-linux-user@lists.sourceforge.net,
       netfilter-devel@lists.netfilter.org, coreteam@netfilter.org
Subject: Re: drivers/infiniband/mlx/mad.c misplaced ;
Message-ID: <20070816145210.GD6670@c2.user-mode-linux.org>
References: <20070815235825.GB17004@redhat.com> <1187224811.5906.55.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187224811.5906.55.camel@localhost>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 05:40:11PM -0700, Joe Perches wrote:
> fs/hostfs/hostfs_user.c:        if(attrs->ia_valid & HOSTFS_ATTR_CTIME) ;

This one can be deleted, but I think I did it for documentation
reasons, to make it clear that ctime handling wasn't left out by
mistake.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
