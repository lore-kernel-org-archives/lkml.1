Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbYFUJQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbYFUJQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 05:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYFUJQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 05:16:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59794 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYFUJQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 05:16:48 -0400
Date: Sat, 21 Jun 2008 02:09:10 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/70] tty updates proposed for 2.6.27
Message-ID: <20080621090910.GA12516@kroah.com>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 08:57:55PM +0100, Alan Cox wrote:
> This patch series introduces the idea of a tty_port - a common structure
> that eventually all ports will have. Some drivers are migrated to make partial
> use of the tty port commonality and helpers but only a little.
> 
> On the USB side the USB tty API is changed to fix a whole pile of races where
> tty->port->tty cannot be assumed to be tty (because of hangup/reopen). The
> USB drivers all get a spring clean and the entire pile have been dragged into
> CodingStyle near compliance (some cases where the checkpatch whines that
> make no sense have been ignored).
> 
> Greg: At the end of this series there shouldn't be any white space issues
> although some earlier patches introduce them and later ones take them away

Ah, thanks for resending these, as they are primarily USB changes, any
objection for me to take these through my USB tree?

greg k-h
