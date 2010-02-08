Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0BHWe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:34:57 -0500
Received: from cantor.suse.de ([195.135.220.2]:54836 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab0BHWey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:34:54 -0500
Date: Sun, 7 Feb 2010 22:55:47 -0800
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: Colin Guthrie <cguthrie@mandriva.org>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver-core: fix race condition in get_device_parent()
Message-ID: <20100208065547.GA12385@suse.de>
References: <4B6BDD5E.7080904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6BDD5E.7080904@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 05:57:02PM +0900, Tejun Heo wrote:
> This fell through the crack.  This patch isn't very pretty but it's
> better than having the race condition open.  Greg, can you please
> apply this?

Yes, I'll queue it up and backport it to the -stable trees when it goes
into Linus's tree.

Thanks for the patch.

greg k-h
