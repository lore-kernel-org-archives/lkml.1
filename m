Return-Path: <linux-kernel-owner+w=401wt.eu-S1764557AbXHVTMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764557AbXHVTMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 15:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbXHVTLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 15:11:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58315 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763446AbXHVTLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 15:11:51 -0400
Date: Wed, 22 Aug 2007 11:59:41 -0700
From: Greg KH <greg@kroah.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>, Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Subject: Re: [stable] [2.6.20.17 review 32/58] fs: 9p/conv.c error path fix
Message-ID: <20070822185941.GA6129@kroah.com>
References: <20070822083844.%N@1wt.eu> <20070822084023.%N@1wt.eu> <a4e6962a0708220853n7689985fj71ba19b67e17ae5d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4e6962a0708220853n7689985fj71ba19b67e17ae5d@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 10:53:02AM -0500, Eric Van Hensbergen wrote:
> On 8/22/07, Willy Tarreau <w@1wt.eu> wrote:
> > When buf_check_overflow() returns != 0 we will hit kfree(ERR_PTR(err))
> > and it will not be happy about it.
> >
> > Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Willy Tarreau <w@1wt.eu>
> Acked-by: Eric Van Hensbergen <ericvh@gmail.com>
> 
> This seems to be in the current code as well, I'll forward-port the patch...

Huh?  It's not already in mainline?  Then how did it ever get into the
stable queue?

Ugh.

greg k-h
